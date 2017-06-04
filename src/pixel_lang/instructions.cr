require "./c24"

require "stumpy_png"

# Holds the 2d array of instructions. Provides a C24 to Instruction interface. 
class Instructions
  alias StartPoint = NamedTuple(x: Int32, y: Int32, direction: Symbol, priority: UInt32)
  
  getter image : StumpyCore::Canvas  
  getter original_image : StumpyCore::Canvas

  def initialize(@image : StumpyCore::Canvas)
    @original_image = @image.dup  
  end

  def initialize(image_file)
    @image = StumpyPNG.read image_file
    @original_image = @image.dup
  end

  def initialize(width, height)
    @image = StumpyCore::Canvas.new(width, height, StumpyCore::RGBA.from_rgb8(255,255,255))
    @original_image = @image.dup    
  end

  # Returns an instruction from position x, y
  def [](x, y) : Instruction
    c24 = C24.from_rgb8(@image[x, y].to_rgb8)
    Instruction.find_instruction(c24).new(c24)
  end

  # Sets an instruction at position x, y
  def []=(x, y, v : Instruction)
    @image[x, y] = StumpyCore::RGBA.from_rgb8(v.value.r, v.value.g, v.value.b)
  end

  # Sets an instruction at position x, y
  def []=(x, y, c24 : C24)
    @image[x, y] = StumpyCore::RGBA.from_rgb8(c24.r, c24.g, c24.b)
  end

  # Gives a list of start points within the program. Used by `Engine`
  def start_points : Array(StartPoint)
    a = [] of StartPoint
    (0...@image.width).each do |x|
      (0...@image.height).each do |y|
         i = self[x, y]
         if i.value[:control_code] == Start.control_code
           a << {
             x: x,
             y: y,
             direction: Piston::DIRECTIONS[i.value[:direction]],
             priority: i.value[:priority]
           }
         end  
      end
    end
    a
  end

  def each
    (0...@image.width).each do |x|
      (0...@image.height).each do |y|
        yield x, y, self[x, y]
      end
    end
  end

  def all?
    result = true
    (0...@image.width).each do |x|
      (0...@image.height).each do |y|
        unless yield x, y, self[x, y]
          result = false 
          break
        end
        break unless result
      end
    end
    result
  end

  def width
    @image.width
  end

  def height
    @image.height
  end
end