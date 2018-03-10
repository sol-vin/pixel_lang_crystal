require "./../instruction"
require "./../piston"

class Direction < Instruction
  def self.control_code
    0x3
  end
  
  def self.run(piston, direction)
    if direction != :random
      piston.change_direction(direction)
    else
      piston.change_direction Constants::BASIC_DIRECTIONS.sample
    end
  end

  def run(piston)
    self.class.run(piston, Constants::DIRECTIONS[value[:value] % Constants::DIRECTIONS.size])
  end
end