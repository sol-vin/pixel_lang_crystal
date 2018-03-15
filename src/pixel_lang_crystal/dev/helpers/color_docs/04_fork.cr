require "./../../../basic/04_fork"

class Fork
  def self.reference_card
    %q{
    Fork Instruction
    Forks a piston into multiple readers with different directions
    0bCCCC000000444X333Y222111
    C = Control Code (Instruction) [4 bits]
    0 = Free bit [14 bits]
    1 = Direction 1 [3 bits] (See Constants::DIRECTIONS for order)
    2 = Direction 2 [3 bits] (See Constants::DIRECTIONS for order)
    Y = Toggle 3rd direction [1 bits]
    3 = Direction 3 [3 bits] (See Constants::DIRECTIONS for order)
    X = Toggle 4th direction [1 bits]    
    4 = Direction 4 [3 bits] (See Constants::DIRECTIONS for order)
    }
  end

  def self.make_color(direction_1, direction_2, direction_3 = nil, direction_4 = nil)
    d1_bits = Constants::DIRECTIONS.index(direction_1).as(Int32) << DIRECTION_1_BITSHIFT
    
    d2_bits = Constants::DIRECTIONS.index(direction_2).as(Int32) << DIRECTION_2_BITSHIFT
    
    d3_bits = 0
    unless direction_3.nil?
      d3_bits = Constants::DIRECTIONS.index(direction_3.as(Symbol)).as(Int32) << DIRECTION_3_BITSHIFT
      d3_bits += 1 << DIRECTION_3_BOOL_BITSHIFT
    end

    d4_bits = 0
    unless direction_4.nil?
      d4_bits = Constants::DIRECTIONS.index(direction_4.as(Symbol)).as(Int32) << DIRECTION_4_BITSHIFT
      d4_bits += 1 << DIRECTION_4_BOOL_BITSHIFT
    end
    
    ((control_code << C24::CONTROL_CODE_BITSHIFT) + d1_bits + d2_bits + d3_bits + d4_bits).to_s 16
  end

  def self.make(direction_1, direction_2, direction_3 = nil, direction_4 = nil)
    self.new(C24.new(make_color(direction_1, direction_2, direction_3, direction_4).to_i 16))
  end

  def arguments
    a = [":#{Constants::DIRECTIONS[value[:direction_1]]}", ":#{Constants::DIRECTIONS[value[:direction_2]]}"]
    a << ":#{Constants::DIRECTIONS[value[:direction_3]]}" if value[:direction_3_bool] == Constants::TRUE
    a << ":#{Constants::DIRECTIONS[value[:direction_4]]}" if value[:direction_4_bool] == Constants::TRUE
    a
  end
end