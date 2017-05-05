require "./bitmask"
require "./bitmask_hash"
require "./instruction"
require "./basic/10_arithmetic"

# Custom color class that will roll over 24-bit ints.
struct C24
  include BitmaskHash
  # min byte
  MIN = 0_u32
  # max byte
  MAX = 0x1000000_u32

  getter value : UInt32 = 0_u32

  def initialize(value : Int | UInt32)
    self.value = value
  end

  # set the value and roll it over or backwards based on the result.
  def value=(x : Int)
    if x < 0
      x = (MAX - (x.abs % MAX) + 1) 
    end
    
    @value = x.to_u32 % MAX
  end

  # get the top byte (red)
  def r : UInt8
    (value & 0xff0000) >> 16
  end

  # get the middle byte (green)
  def g : UInt8
    (value & 0x00ff00) >> 8
  end

  # get the bottom byte (blue)
  def b : UInt8
    (value & 0x0000ff)
  end

  # set the top byte (red)
  def r=(v : UInt8)
    v = v % 0x1000
    @value = (v << 16) + (g << 8) + b
  end

  # set the middle byte (green)
  def g=(v : UInt8)
    v = v % 0x1000
    @value = (r << 16) + (v << 8) + b
  end

  # set the bottom byte (blue)
  def b=(v : UInt8)
    v = v % 0x1000
    @value = (r << 16) + (g << 8) + v
  end

  def to_u32 :  UInt32
    value
  end

  def to_hex : String
    "0x" + to_u32.to_s(16).rjust(6, '0')
  end

  def to_s(n) : String
    value.to_s(n)
  end

  def eql?(other : C24)
    self.value == other.value
  end

  def eql? (other : Int)
    self.value == other
  end

    
  {% for op in Arithmetic::OPERATIONS %}
    #C24 op C24
    def {{op.id}}(other : C24) : C24
      new_value = self.value {{op.id}} other.value
      new_value = (new_value ? Instruction::LOGICAL_TRUE : Instruction::LOGICAL_FALSE) if new_value.is_a? Bool
      C24.new(new_value)
    end
    
    #C24 op Int
    def {{op.id}}(other : Int) : C24
      new_value = self.value {{op.id}} other
      new_value = (new_value ? Instruction::LOGICAL_TRUE : Instruction::LOGICAL_FALSE) if new_value.is_a? Bool
      C24.new(new_value.to_i)
    end
  {% end %}
end

struct C24
  WHITE = Color24.new(0xffffff_u32)
  BLACK = Color24.new(0x000000_u32)
  RED = Color24.new (0xff0000_u32)
  GREEN = Color24.new (0x00ff00_u32)
  BLUE = Color24.new(0x0000ff_u32)
end