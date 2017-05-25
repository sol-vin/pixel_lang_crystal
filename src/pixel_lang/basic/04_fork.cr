require "./../instruction"
require "./../piston"

class Fork < Instruction
  DECISIONS = {
    :up => ->(p : Piston){p.change_direction(:up)},
    :down => ->(p : Piston){p.change_direction(:down)},
    :left => ->(p : Piston){p.change_direction(:left)},
    :right => ->(p : Piston){p.change_direction(:right)},
    :turn_left => ->(p : Piston){p.change_direction(:turn_left)},
    :turn_right => ->(p : Piston){p.change_direction(:turn_right)},
    :reverse => ->(p : Piston){p.change_direction(:reverse)},
    :random => ->(p : Piston){p.change_direction(:random)}
  }
  DIRECTION_1_BITS = 3
  DIRECTION_1_BITSHIFT = 0

  DIRECTION_2_BITS = 3
  DIRECTION_2_BITSHIFT = 3

  DIRECTION_3_BOOL_BITS = 1
  DIRECTION_3_BOOL_BITSHIFT = 6

  DIRECTION_3_BITS = 3
  DIRECTION_3_BITSHIFT = 7

  DIRECTION_4_BOOL_BITS = 1
  DIRECTION_4_BOOL_BITSHIFT = 10

  DIRECTION_4_BITS = 3
  DIRECTION_4_BITSHIFT = 11
  
  def self.control_code
    0x4
  end

  def self.reference_card
    %q{
    Fork Instruction
    Forks a piston into multiple readers with different directions
    0bCCCC000000444X333Y222111
    C = Control Code (Instruction) [4 bits]
    0 = Free bit [14 bits]
    1 = Direction 1 [3 bits] (See Direction::DIRECTIONS for order)
    2 = Direction 2 [3 bits] (See Direction::DIRECTIONS for order)
    Y = Toggle 3rd direction [1 bits]
    3 = Direction 3 [3 bits] (See Direction::DIRECTIONS for order)
    X = Toggle 4th direction [1 bits]    
    4 = Direction 4 [3 bits] (See Direction::DIRECTIONS for order)
    }
  end
  #TODO: FIX THIS!
  def self.make_color(direction_1, direction_2, direction_3 = nil, direction_4 = nil)
    d1_bits = DECISIONS.keys.index(direction_1).as(Int32) << DIRECTION_1_BITSHIFT
    
    d2_bits = DECISIONS.keys.index(direction_2).as(Int32) << DIRECTION_2_BITSHIFT
    
    d3_bits = 0
    unless direction_3.nil?
      d3_bits = DECISIONS.keys.index(direction_3.as(Symbol)).as(Int32) << DIRECTION_3_BITSHIFT
      d3_bits += 1 << DIRECTION_3_BOOL_BITSHIFT
    end

    d4_bits = 0
    unless direction_4.nil?
      d4_bits = DECISIONS.keys.index(direction_4.as(Symbol)).as(Int32) << DIRECTION_4_BITSHIFT
      d4_bits += 1 << DIRECTION_4_BOOL_BITSHIFT
    end
    
    ((control_code << C24::CONTROL_CODE_BITSHIFT) + d1_bits + d2_bits + d3_bits + d4_bits).to_s 16
  end

  def self.make(direction_1, direction_2, direction_3 = nil, direction_4 = nil)
    Fork.new(C24.new(make_color(direction_1, direction_2, direction_3, direction_4).to_i 16))
  end

  def self.run(piston, direction_1, direction_2, direction_3 = nil, direction_4 = nil)
    unless direction_4.nil?
      p = piston.clone
      DECISIONS[direction_4].call(p)
      p.move 1
      piston.engine.merge(piston, p)
    end

    unless direction_3.nil?
      p = piston.clone
      DECISIONS[direction_3].call(p)
      p.move 1
      piston.engine.merge(piston, p)
    end

    p = piston.clone
    DECISIONS[direction_2].call(p)
    p.move 1
    piston.engine.merge(piston, p)

    DECISIONS[direction_1].call(piston)
  end

  def initialize(value : C24)
    super value
    @value.add_mask(:direction_1, DIRECTION_1_BITS, DIRECTION_1_BITSHIFT)
    @value.add_mask(:direction_2, DIRECTION_2_BITS, DIRECTION_2_BITSHIFT)
    @value.add_mask(:direction_3_bool, DIRECTION_3_BOOL_BITS, DIRECTION_3_BOOL_BITSHIFT)
    @value.add_mask(:direction_3, DIRECTION_3_BITS, DIRECTION_3_BITSHIFT)
    @value.add_mask(:direction_4_bool, DIRECTION_4_BOOL_BITS, DIRECTION_4_BOOL_BITSHIFT)
    @value.add_mask(:direction_4, DIRECTION_4_BITS, DIRECTION_4_BITSHIFT)
  end

  def run(piston)
    d1 = DECISIONS.keys[value[:direction_1]]
    d2 = DECISIONS.keys[value[:direction_2]]
    d3 = (value[:direction_3_bool] != 0 ? DECISIONS.keys[value[:direction_3]] : nil)
    d4 = (value[:direction_4_bool] != 0 ? DECISIONS.keys[value[:direction_4]] : nil)
    self.class.run(piston, d1, d2, d3, d4)
  end
  
  def info
    # Table with headings
    table = super
    table << ["direction_1", DECISIONS.keys[value[:direction_1]].to_s]
    table << ["direction_2", DECISIONS.keys[value[:direction_2]].to_s]
    table << ["direction_3_bool", value[:direction_3_bool].to_s]
    table << ["direction_3", DECISIONS.keys[value[:direction_3]].to_s]
    table << ["direction_4_bool", value[:direction_4_bool].to_s]
    table << ["direction_4", DECISIONS.keys[value[:direction_4]].to_s]
    table
  end
end