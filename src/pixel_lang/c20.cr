require "./bitmask"
require "./bitmask_hash"
require "./constants"
struct C20
  # min byte
  MIN = 0_u32
  # max byte
  MAX = 0x100000_u32

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

  def eql?(other : C20)
    self.value == other.value
  end

  def eql? (other : Int)
    self.value == other
  end

  {% for op in Constants::OPERATIONS %}
    #C24 op C24
    def {{op.id}}(other : C20) : C20
      new_value = self.value {{op.id}} other.value
      new_value = (new_value ? Constants::TRUE : Constants::FALSE) if new_value.is_a? Bool
      C20.new(new_value)
    end
    
    #C24 op Int
    def {{op.id}}(other : Int) : C20
      new_value = self.value {{op.id}} other
      new_value = (new_value ? Constants::TRUE : Constants::FALSE) if new_value.is_a? Bool
      C20.new(new_value.to_i)
    end
  {% end %}
end
