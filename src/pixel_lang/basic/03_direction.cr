require "./../instruction"
require "./../piston"

class Direction < Instruction
  DIRECTIONS = Piston::DIRECTIONS + [:turn_left, :turn_right, :reverse, :random]

  def self.control_code
    0x3
  end

  def self.reference_card
    puts %q{
    Direction Instruction
    Tells a piston to change direction
    0bCCCC0000000000000000DDDD
    C = Control Code (Instruction) [4 bits]
    0 = Free bit [18 bits]
    D = Direction [2 bits] (See Pistion::DIRECTIONS for order)
    }
  end

  def self.make_color(direction)
    direction_bits = DIRECTIONS.index(direction)
    ((control_code << CONTROL_CODE_BITSHIFT) + direction_bits).to_s 16
  end

  def self.run(piston, direction)
    if direction != :random
      piston.change_direction(direction)
    else
      piston.change_direction Piston::DIRECTIONS.sample
    end
  end

  def run(piston)
    self.class.run(piston, DIRECTIONS[value[:direction] % DIRECTIONS.size])
  end
end