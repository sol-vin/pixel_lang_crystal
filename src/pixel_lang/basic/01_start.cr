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

  def info
    # Table with headings
    table = super
    table << ["priority", "#{value[:priority]}"]
    table << ["direction", "#{Piston::DIRECTIONS[value[:direction]]}"]
    table
  end
end