require "./../../../basic/10_arithmetic"

class Arithmetic
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
    self.new(C20.new(make_color(s1, s1op, op, s2, s2op, d, dop, invert).to_i 16))
  end

  def arguments
    s1 = ":#{Piston::REGISTERS[value[:s1]]}"
    s1op = "#{value[:s1op]}"

    op = ":#{Constants::OPERATIONS[value[:op]]}"

    s2 = ":#{Piston::REGISTERS[value[:s2]]}"
    s2op = "#{value[:s2op]}"

    d = ":#{Piston::REGISTERS[value[:d]]}"
    dop = "#{value[:dop]}"

    invert = "#{value[:invert] == Constants::TRUE}"
    [s1, s1op, op, s2, s2op, d, dop, invert]
  end
end