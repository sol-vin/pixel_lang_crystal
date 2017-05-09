require "./../instruction"
require "./../piston"

class Conditional < Instruction
  def self.control_code
    0x7
  end

  DECISIONS = {
    :up => ->(p : Piston){p.change_direction(:up)},
    :down => ->(p : Piston){p.change_direction(:down)},
    :left => ->(p : Piston){p.change_direction(:left)},
    :right => ->(p : Piston){p.change_direction(:right)},
    :turn_left => ->(p : Piston){p.change_direction(:turn_left)},
    :turn_right => ->(p : Piston){p.change_direction(:turn_right)},
    :reverse => ->(p : Piston){p.change_direction(:reverse)},
    :random => ->(p : Piston){p.change_direction Piston::DIRECTIONS.sample}
  }

  TRUE_BITS = 3
  TRUE_BITSHIFT = 17 

  FALSE_BITS = 3
  FALSE_BITSHIFT = 14

  SOURCE_1_BITS = 3
  SOURCE_1_BITSHIFT = 11

  SOURCE_1_OPTION_BITS = 2
  SOURCE_1_OPTION_BITSHIFT = 9

  OPERATION_BITS = 4
  OPERATION_BITSHIFT = 5

  SOURCE_2_BITS = 3
  SOURCE_2_BITSHIFT = 2

  SOURCE_2_OPTION_BITS = 2
  SOURCE_2_OPTION_BITSHIFT = 0

  def self.reference_card
    puts %q{
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

  def self.make_color(type, s1, s1op, op, s2, s2op)
    type_bits = TYPES.index(type) << TYPE_BITSHIFT
    s1_bits = Piston::REGISTERS.index(s1) << SOURCE_1_BITSHIFT
    s1op_bits = s1op << SOURCE_1_OPTIONS_BITSHIFT
    op_bits = Constants::OPERATIONS.index(op) << OPERATION_BITSHIFT
    s2_bits = Piston::REGISTERS.index(s2) << SOURCE_2_BITSHIFT
    s2op_bits = s2op << SOURCE_2_OPTIONS_BITSHIFT

    ((control_code <<C24::CONTROL_CODE_BITSHIFT) + type + s1 + s1op + op + s2 + s2op).to_s 16
  end

  def self.make(type, s1, s1op, op, s2, s2op)
    Conditional.new(C24.new(make_color(type, s1, s1op, op, s2, s2op).to_i 16))
  end

  def self.run(piston, true_action : Symbol, false_action : Symbol,  s1 : Symbol, s1op : Int, op : Symbol, s2 : Symbol, s2op : Int)
    result = piston.do_math(s1, s1op, op, s2, s2op)

    if result.value == Constants::FALSE
      DECISIONS[true_action].call piston
    else
      DECISIONS[false_action].call piston
    end
  end


  def initialize(value : C24)
    super value
    @value.add_mask(:true_action, TRUE_BITS, TRUE_BITSHIFT)
    @value.add_mask(:false_action, FALSE_BITS, FALSE_BITSHIFT)    
    @value.add_mask(:s1, SOURCE_1_BITS, SOURCE_1_BITSHIFT)
    @value.add_mask(:s1op, SOURCE_1_OPTION_BITS, SOURCE_1_OPTION_BITSHIFT)
    @value.add_mask(:op, OPERATION_BITS, OPERATION_BITSHIFT)
    @value.add_mask(:s2, SOURCE_2_BITS, SOURCE_2_BITSHIFT)
    @value.add_mask(:s2op, SOURCE_2_OPTION_BITS, SOURCE_2_OPTION_BITSHIFT)
  end

  def run(piston : Piston)
    true_action = DECISIONS.keys[value[:true_action]]
    false_action = DECISIONS.keys[value[:false_action]]
    s1 = Piston::REGISTERS[value[:s1]]
    op = Constants::OPERATIONS[value[:op]]
    s2 = Piston::REGISTERS[value[:s2]]
    
    self.class.run(piston, true_action, false_action, s1, value[:s1op], op, s2, value[:s2op])
  end
end