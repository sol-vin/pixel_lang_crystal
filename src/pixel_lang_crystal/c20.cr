require "./bitmask"
require "./bitmask_hash"
require "./constants"

# A 20-bit unsigned integer
struct C20
  # min byte
  MIN = 0_u32
  # max byte
  MAX = 0x100000_u32

  getter value : UInt32 = 0_u32

  def initialize(value : Int = 0)
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
    to_u32.to_s(16).upcase.rjust(5, '0')
  end

  def to_c : Char
    (to_u32 % 0x100).chr
  end
  
  # outputs a hexadecimal value prefixed with 0x (0xffffff)
  def to_char_hex : String
    (to_u32 % 0x100).to_s(16).upcase.rjust(2, '0')
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

  {% for op in Constants::ARITHMETIC_OPERATIONS %}
    #C20 op C20
    def {{op.id}}(other : C20) : C20
      new_value = self.value {{op.id}} other.value
      C20.new(new_value)
    end
    
    #C20 op Int
    def {{op.id}}(other : Int) : C20
      new_value = self.value {{op.id}} other
      C20.new(new_value.to_i)
    end
  {% end %}

  {% for op in Constants::BOOLEAN_OPERATIONS %}
    #C20 op C20
    def {{op.id}}(other : C20) : Bool
      self.value {{op.id}} other.value
    end
    
    #C20 op Int
    def {{op.id}}(other : Int) : Bool
      self.value {{op.id}} other
    end
  {% end %}
end
