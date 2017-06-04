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

  def self.reference_card
    %q{
    Arithmetic Instruction
    Performs an arithmatic operation and stores the output in a register
    0bCCCC111XXOOOO222YYDDDZZI
    C = Control Code (Instruction) [4 bits]
    1 = Source 1 [3 bits]
    X = Source Options [2 bits]
    O = Operation [4 bits]
    2 = Source 2 [3 bits]
    Y = Source Options [2 bits]
    D = Destination [3 bits]
    Z = Destination Options [2 bits]
    I = Invert? [1 bit]
    }
  end

  def self.make_color(s1, s1op, op, s2, s2op, d, dop, invert = false)
    s1b = Piston::REGISTERS.index(s1).as(Int32) << SOURCE_1_BITSHIFT
    s1opb = s1op << SOURCE_1_OPTION_BITSHIFT
    opb = Constants::OPERATIONS.index(op).as(Int32) << OPERATION_BITSHIFT
    s2b = Piston::REGISTERS.index(s2).as(Int32) << SOURCE_2_BITSHIFT
    s2opb = s2op << SOURCE_2_OPTION_BITSHIFT
    db = Piston::REGISTERS.index(d).as(Int32) << DESTINATION_BITSHIFT
    dopb = dop << DESTINATION_OPTION_BITSHIFT
    invertb = (invert ? 1 : 0) << INVERT_BITSHIFT
    ((control_code << C24::CONTROL_CODE_BITSHIFT) + s1b + s1opb + opb + s2b + s2opb + db + dopb + invertb).to_s 16
  end

  def self.make(s1, s1op, op, s2, s2op, d, dop, invert = false)
    Arithmetic.new(C24.new(make_color(s1, s1op, op, s2, s2op, d, dop, invert).to_i 16))
  end

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

  def info
    # Table with headings
    table = super
    table << ["s1", Piston::REGISTERS[value[:s1]].to_s]
    table << ["s1op", value[:s1op].to_s]
    table << ["op", Constants::OPERATIONS[value[:op]].to_s]
    table << ["s2", Piston::REGISTERS[value[:s2]].to_s]
    table << ["s2op", value[:s2op].to_s]
    table << ["d", Piston::REGISTERS[value[:d]].to_s]
    table << ["dop", value[:dop].to_s]
    table << ["invert", (value[:invert] != 0).to_s]
    table
  end
end
