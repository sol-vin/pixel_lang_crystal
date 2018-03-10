require "./../../../basic/03_direction"

class Direction
  def self.reference_card
    %q{
    Direction Instruction
    Tells a piston to change direction
    0bCCCC0000000000000000DDDD
    C = Control Code (Instruction) [4 bits]
    0 = Free bit [18 bits]
    D = Direction [2 bits] (See Pistion::DIRECTIONS for order)
    }
  end

  def self.make_color(direction : Symbol)
    direction_bits = Constants::DIRECTIONS.index(direction).as(Int32)
    ((control_code << C24::CONTROL_CODE_BITSHIFT) + direction_bits).to_s 16
  end

  def self.make(direction : Symbol)
    self.new(C24.new(make_color(direction).to_i 16))
  end
end