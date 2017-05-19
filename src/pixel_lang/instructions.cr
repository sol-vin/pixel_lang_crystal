require "./c24"

require "stumpy_png"

class Instructions
  alias StartPoint = NamedTuple(x: UInt32, y: UInt32, direction: Symbol, priority: UInt32)

  def initialize(@image : StumpyCore::Canvas)
  end

  def initialize(image_file)
    @image = StumpyPNG.read image_file
  end

  def initialize(width, height)
    @image = StumpyCore::Canvas.new(width, height, StumpyCore::RGBA.from_rgb8(255,255,255))
  end

  def [](x, y) : Instruction
    c24 = C24.from_rgb8(@image[x, y].to_rgb8)
    Instruction.find_instruction(c24).new(c24)
  end

  def []=(x, y, v : Instruction)
    @image[x, y] = StumpyCore::RGBA.from_rgb8(v.value.r, v.value.g, v.value.b)
  end

  def []=(x, y, c24 : C24)
    @image[x, y] = StumpyCore::RGBA.from_rgb8(c24.r, c24.g, c24.b)
  end

  def start_points : Array(StartPoint)
    a = [] of StartPoint
    (0...@image.width).each do |x|
      (0...@image.height).each do |y|
         i = self[x, y]
         if i.value[:control_code] == 0x1
           a << {
             x: x.to_u32,
             y: y.to_u32,
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
        result = false unless yield x, y, self[x, y]
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