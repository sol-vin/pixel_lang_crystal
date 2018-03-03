require "./../../../basic/07_conditional"

class Conditional
  def self.reference_card
    %q{
    Conditional Instruction
    Evaluates an arithmetic expression. If the result is zero, the piston moves one way, else, it moves another.
     0bCCCCTTTFFF111XXAAAA222YY
     C = Control Code (Instruction) [4 bits]
     T = True Action [3 bit]
     F = False Action [3 bit]
     1 = Source 1 Register [3 bits]
     X = Source 1 option [2 bits]
     A = Arithmatic Operation [4 bits] (See Constants::OPERATIONS)
     2 = Source 2 Register [3 bits]
     Y = Source 2 option [2 bits]
    }
  end

  def self.make_color(t, f, s1, s1op, op, s2, s2op)
    true_bits = DECISIONS.keys.index(t).as(Int32) << TRUE_BITSHIFT
    false_bits = DECISIONS.keys.index(f).as(Int32) << FALSE_BITSHIFT    
    s1_bits = Piston::REGISTERS.index(s1).as(Int32) << SOURCE_1_BITSHIFT
    s1op_bits = s1op << SOURCE_1_OPTION_BITSHIFT
    op_bits = Constants::OPERATIONS.index(op).as(Int32) << OPERATION_BITSHIFT
    s2_bits = Piston::REGISTERS.index(s2).as(Int32) << SOURCE_2_BITSHIFT
    s2op_bits = s2op << SOURCE_2_OPTION_BITSHIFT

    ((control_code << C24::CONTROL_CODE_BITSHIFT) + true_bits + false_bits + s1_bits + s1op_bits + op_bits + s2_bits + s2op_bits).to_s 16
  end

  def self.make(t, f, s1, s1op, op, s2, s2op)
    self.new(C24.new(make_color(t, f, s1, s1op, op, s2, s2op).to_i 16))
  end
end