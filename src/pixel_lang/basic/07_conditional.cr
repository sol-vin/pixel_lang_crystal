require "./../instruction"
require "./../piston"

class Conditional < Instruction
  def self.control_code
    0x7
  end

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

  def self.run(piston, true_action : Symbol, false_action : Symbol,  s1 : Symbol, s1op : Int, op : Symbol, s2 : Symbol, s2op : Int)
    if evaluate(piston, s1, s1op, op, s2, s2op)
      piston.change_direction(true_action)
    else
      piston.change_direction(false_action)
    end
  end

  def self.evaluate(piston, s1 : Symbol, s1op : Int, op : Symbol, s2 : Symbol, s2op : Int)
    result = piston.evaluate(s1, s1op, op, s2, s2op)

    if result.value == Constants::FALSE
      false
    else
      true
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
    true_action = Constants::DIRECTIONS[value[:true_action]]
    false_action =  Constants::DIRECTIONS[value[:false_action]]
    s1 = Piston::REGISTERS[value[:s1]]
    op = Constants::OPERATIONS[value[:op]]
    s2 = Piston::REGISTERS[value[:s2]]
    
    self.class.run(piston, true_action, false_action, s1, value[:s1op], op, s2, value[:s2op])
  end

  def evaluate(piston)
    s1 = Piston::REGISTERS[value[:s1]]
    op = Constants::OPERATIONS[value[:op]]
    s2 = Piston::REGISTERS[value[:s2]]
    result = piston.evaluate(s1, value[:s1op], op, s2, value[:s2op])

    if result.value == Constants::FALSE
      false
    else
      true
    end
  end

  def info
    # Table with headings
    table = super
    table << ["true_action",  Constants::DIRECTIONS[value[:true_action]].to_s]
    table << ["false_action",  Constants::DIRECTIONS[value[:false_action]].to_s]
    table << ["s1", Piston::REGISTERS[value[:s1]].to_s]
    table << ["s1op", value[:s1op].to_s]
    table << ["op", Constants::OPERATIONS[value[:op]].to_s]
    table << ["s2", Piston::REGISTERS[value[:s2]].to_s]
    table << ["s2op", value[:s2op].to_s] 
    
    table
  end
end