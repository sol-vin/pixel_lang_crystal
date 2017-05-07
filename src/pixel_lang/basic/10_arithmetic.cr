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

  def self.reference_card
    puts %q{
    Arithmetic Instruction
    Performs an arithmatic operation and stores the output in a register
    0bCCCC111XXOOOO222YYDDDZZ0
    C = Control Code (Instruction) [4 bits]
    1 = Source 1 [3 bits]
    X = Source Options [2 bits]
    O = Operation [4 bits]
    2 = Source 2 [3 bits]
    Y = Source Options [2 bits]
    D = Destination [3 bits]
    Z = Destination Options [2 bits]
    0 = Free bit [1 bit]
    }
  end

  def self.make_color(s1, s1op, op, s2, s2op, d, dop)
    s1b = Piston::REGISTERS.index(s1) << SOURCE_1_BITSHIFT
    s1opb = s1op << SOURCE_1_OPTIONS_BITSHIFT
    opb = Constants::OPERATIONS.index(op) << OPERATION_BITSHIFT
    s2b = Piston::REGISTERS.index(s2) << SOURCE_2_BITSHIFT
    s2opb = s2op << SOURCE_2_OPTION_BITSHIFT
    db = Piston::REGISTERS.index(d) << DESTINATION_BITSHIFT
    dopb = dop << DESTINATION_OPTION_BITSHIFT


    ((control_code << CONTROL_CODE_BITSHIFT) + s1b + s1opb + opb + s2b + s2opb + db + dopb).to_s 16
  end

  def self.run(piston, s1, s1op, op, s2, s2op, d, dop)
    piston.set(d, piston.do_math(s1, s1op, op, s2, s2op), dop)
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
  end

  def run(piston)
    s1 = Piston::REGISTERS[value[:s1]]
    s1op = value[:s1op]
    op = Constants::OPERATIONS[value[:op]]
    s2 = Piston::REGISTERS[value[:s2]]
    s2op = value[:s2op]
    d = Piston::REGISTERS[value[:d]]
    dop = value[:dop]
    self.class.run(piston, s1, s1op, op, s2, s2op, d, dop)
  end
end
