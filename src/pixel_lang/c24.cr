require "./bitmask"
require "./bitmask_hash"
require "./constants"
# Custom color class that will roll over 24-bit ints.
struct C24
  # min byte
  MIN = 0_u32
  # max byte
  MAX = 0x1000000_u32

  getter value : UInt32 = 0_u32

  def initialize(value : Int)
    self.value = value
  end

  # set the value and roll it over or backwards based on the result.
  def value=(x : Int)
    if x < 0
      x = (MAX - (x.abs % MAX)) 
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

  # outputs a hexadecimal value prefixed with 0x (0xffffff)
  def to_int_hex : String
    "0x" + to_u32.to_s(16).rjust(5, '0')
  end

  def to_c : Char
    (to_u32 % 0x100).chr
  end
  
  # outputs a hexadecimal value prefixed with 0x (0xffffff)
  def to_char_hex : String
    "0x" + (to_u32 % 0x100).to_s(16).rjust(2, '0')
  end

  def to_s : String
    value.to_s
  end

  def eql?(other : C24)
    self.value == other.value
  end

  def eql? (other : Int)
    self.value == other
  end

  {% for op in Constants::OPERATIONS %}
    #C24 op C24
    def {{op.id}}(other : C24) : C24
      new_value = self.value {{op.id}} other.value
      new_value = (new_value ? Constants::TRUE : Constants::FALSE) if new_value.is_a? Bool
      C24.new(new_value)
    end
    
    #C24 op Int
    def {{op.id}}(other : Int) : C24
      new_value = self.value {{op.id}} other
      new_value = (new_value ? Constants::TRUE : Constants::FALSE) if new_value.is_a? Bool
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