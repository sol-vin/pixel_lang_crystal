require "./c24"

require "stumpy_png"

# Holds the 2d array of instructions. Provides a C24 to Instruction interface. 
class Instructions
  alias StartPoint = NamedTuple(x: Int32, y: Int32, direction: Symbol, priority: UInt32)
  getter image_file : String = ""
  getter image : StumpyCore::Canvas  

  def initialize(@image : StumpyCore::Canvas)
  end

  def initialize(image_file)
    @image_file = image_file
    @image = StumpyPNG.read image_file
  end

  def initialize(width, height)
    @image = StumpyCore::Canvas.new(width, height, StumpyCore::RGBA.from_rgb8(255,255,255))
  end
  
  def save(path)
    StumpyPNG.write(@image, path)
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
             direction: Constants::BASIC_DIRECTIONS[i.value[:direction]],
             priority: i.value[:priority]
           }
         end  
      end
    end
    a.sort {|a,b| a[:priority] <=> b[:priority]}
  end

  def each
    (0...@image.width).each do |x|
      (0...@image.height).each do |y|
        yield x, y, self[x, y]
      end
    end
  end

  def map
    (0...@image.width).each do |x|
      (0...@image.height).each do |y|
        self[x, y] = yield x, y, self[x, y]
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

  def reset
    @image = StumpyPNG.read @image_file unless @image_file.empty?
  end
end