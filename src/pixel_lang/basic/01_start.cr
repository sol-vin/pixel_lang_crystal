require "./../instruction"
require "./../piston"

class Start < Instruction
  DIRECTION_BITS = 2
  DIRECTION_BITSHIFT = 18

  PRIORITY_BITS = 18
  PRIORITY_BITSHIFT = 0

  def self.control_code
    0x1
  end

  def self.reference_card
    puts %q{
    Start Instruction
    Tell the engine where to place a piston, what direction it should face, and what it's priority should be.
    0bCCCCDDPPPPPPPPPPPPPPPPPP
    C = Control Code (Instruction) [4 bits]
    D = Direction [2 bits] Direction where the piston should go
    P = Priority [18 bits] Order in which piston should run their cycles. 0 goes first.
    }
  end

  def self.make_color(direction, priority)
    direction_bits = Piston::DIRECTIONS.index(direction) << DIRECTION_BITSHIFT

    if priority > PRIORITY_BITMASK
      fail "Priority #{priority.to_s 16} cannot be higher than #{PRIORITY_BITMASK} or #{PRIORITY_BITMASK.to_s 16}"
    end

    ((control_code << CONTROL_CODE_BITSHIFT) + direction_bits + priority).to_s 16
  end

  def self.run(piston, direction)
    piston.change_direction(direction)
  end

  def initialize(@value : C24)
    @value.add_mask(:direction, DIRECTION_BITS, DIRECTION_BITSHIFT)
    @value.add_mask(:priority, PRIORITY_BITS, PRIORITY_BITSHIFT)
  end

  def run(piston)
    self.class.run(piston, Piston::DIRECTIONS[value[:direction]])
  end
end