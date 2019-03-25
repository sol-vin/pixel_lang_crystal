require "./../instruction"
require "./../piston"

class Fork < Instruction
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

  DIRECTION_5_BOOL_BITS = 1
  DIRECTION_5_BOOL_BITSHIFT = 14

  DIRECTION_5_BITS = 3
  DIRECTION_5_BITSHIFT = 15

  
  
  def self.control_code
    0x4
  end

  def self.run(piston, direction_1, direction_2, direction_3 = nil, direction_4 = nil, direction_5 = nil)
    unless direction_4.nil?
      p = piston.clone_new
      p.change_direction(direction_4)
      p.move 1
      piston.engine.merge(piston, p)
    end

    unless direction_3.nil?
      p = piston.clone_new
      p.change_direction(direction_3)
      p.move 1
      piston.engine.merge(piston, p)
    end

    unless direction_5.nil?
      p = piston.clone_new
      p.change_direction(direction_5)
      p.move 1
      piston.engine.merge(piston, p)
    end

    p = piston.clone_new
    p.change_direction(direction_2)
    p.move 1
    piston.engine.merge(piston, p)

    piston.change_direction(direction_1)
  end

  def initialize(value : C24)
    super value
    @value.add_mask(:direction_1, DIRECTION_1_BITS, DIRECTION_1_BITSHIFT)
    @value.add_mask(:direction_2, DIRECTION_2_BITS, DIRECTION_2_BITSHIFT)
    @value.add_mask(:direction_3_bool, DIRECTION_3_BOOL_BITS, DIRECTION_3_BOOL_BITSHIFT)
    @value.add_mask(:direction_3, DIRECTION_3_BITS, DIRECTION_3_BITSHIFT)
    @value.add_mask(:direction_4_bool, DIRECTION_4_BOOL_BITS, DIRECTION_4_BOOL_BITSHIFT)
    @value.add_mask(:direction_4, DIRECTION_4_BITS, DIRECTION_4_BITSHIFT)
    @value.add_mask(:direction_5_bool, DIRECTION_5_BOOL_BITS, DIRECTION_5_BOOL_BITSHIFT)
    @value.add_mask(:direction_5, DIRECTION_5_BITS, DIRECTION_5_BITSHIFT)
  end

  def run(piston)
    d1 = Constants::DIRECTIONS[value[:direction_1]]
    d2 = Constants::DIRECTIONS[value[:direction_2]]
    d3 = (value[:direction_3_bool] != 0 ? Constants::DIRECTIONS[value[:direction_3]] : nil)
    d4 = (value[:direction_4_bool] != 0 ? Constants::DIRECTIONS[value[:direction_4]] : nil)
    d5 = (value[:direction_5_bool] != 0 ? Constants::DIRECTIONS[value[:direction_5]] : nil)

    self.class.run(piston, d1, d2, d3, d4, d5)
  end
end