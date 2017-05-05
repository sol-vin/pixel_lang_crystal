require "./bitmask_hash"
require "./c24"

class Instruction
  LOGICAL_FALSE = 0
  LOGICAL_TRUE = 1

  CONTROL_CODE_BITS = 4
  CONTROL_CODE_BITSHIFT = 20

  VALUE_BITS = 20
  VALUE_BITSHIFT = 0

  VALUE_MAX = 0x100000

  def self.control_code : Int32
    -1
  end

  def self.match(c24 : C24) : Bool
    CONTROL_CODE == c24[:control_code]
  end

  getter value : C24

  def initialize(value : UInt32)
    @value = C24.new value
    @value.add_mask(:control_code, CONTROL_CODE_BITS, CONTROL_CODE_BITSHIFT)
    @value.add_mask(:value, VALUE_BITS, VALUE_BITSHIFT)
  end

  def run(piston)
    self.class.run(piston)
  end
end