require './../instruction'
require './../piston'

class Direction < Instruction
  DIRECTION_BITS = 3
  DIRECTION_BITSHIFT = 0

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
    if Piston::DIRECTIONS.include? direction
      piston.change_direction(direction)
    elsif DIRECTIONS.include? direction
      case direction
        when :turn_left
          piston.turn_left
        when :turn_right
          piston.turn_right
        when :reverse
          piston.reverse
        when :random
          piston.change_direction Piston::DIRECTIONS.sample
      end
    else
      fail
    end
  end

  def initialize(value : UInt32)
    super value
    @value.add_mask(:direction, DIRECTION_BITS, DIRECTION_BITSHIFT)
  end

  def run(piston)
    self.class.run(piston, DIRECTIONS[value[:direction]])
  end
end