require "./../instruction"
require "./../piston"

class Arithmetic < Instruction
  def self.control_code
    0xA
  end

  SOURCE_1_BITS = 3
  SOURCE_1_BITSHIFT = 17

  SOURCE_1_OPTION_BITS = 2
  SOURCE_1_OPTION_BITSHIFT = 15

  OPERATION_BITS = 4
  OPERATION_BITSHIFT = 11

  SOURCE_2_BITS = 3
  SOURCE_2_BITSHIFT = 8

  SOURCE_2_OPTION_BITS = 2
  SOURCE_2_OPTION_BITSHIFT = 6

  DESTINATION_BITS = 3
  DESTINATION_BITSHIFT = 3

  DESTINATION_OPTION_BITS = 2
  DESTINATION_OPTION_BITSHIFT = 1

  INVERT_BITS = 1
  INVERT_BITSHIFT = 0

  def self.run(piston, s1, s1op, op, s2, s2op, d, dop, invert = false)
    if invert
      piston.set(d, C20.new(C20::MAX) - piston.evaluate(s1, s1op, op, s2, s2op), dop)    
    else
      piston.set(d, piston.evaluate(s1, s1op, op, s2, s2op), dop)
    end
  end

  def initialize(value : C24)
    super value
    @value.add_mask(:s1, SOURCE_1_BITS, SOURCE_1_BITSHIFT)
    @value.add_mask(:s1op, SOURCE_1_OPTION_BITS, SOURCE_1_OPTION_BITSHIFT)
    @value.add_mask(:op, OPERATION_BITS, OPERATION_BITSHIFT)
    @value.add_mask(:s2, SOURCE_2_BITS, SOURCE_2_BITSHIFT)
    @value.add_mask(:s2op, SOURCE_2_OPTION_BITS, SOURCE_2_OPTION_BITSHIFT)
    @value.add_mask(:d, DESTINATION_BITS, DESTINATION_BITSHIFT)
    @value.add_mask(:dop, DESTINATION_OPTION_BITS, DESTINATION_OPTION_BITSHIFT)
    @value.add_mask(:invert, INVERT_BITS, INVERT_BITSHIFT)
  end

  def run(piston)
    s1 = Piston::REGISTERS[value[:s1]]
    s1op = value[:s1op]
    op = Constants::OPERATIONS[value[:op]]
    s2 = Piston::REGISTERS[value[:s2]]
    s2op = value[:s2op]
    d = Piston::REGISTERS[value[:d]]
    dop = value[:dop]
    invert = (value[:invert] != 0)
    self.class.run(piston, s1, s1op, op, s2, s2op, d, dop, invert)
  end
end
