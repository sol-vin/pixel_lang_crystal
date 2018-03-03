require "./../instruction"
require "./../piston"

class Direction < Instruction
  DIRECTIONS = Piston::DIRECTIONS + [:turn_left, :turn_right, :reverse, :random]

  def self.control_code
    0x3
  end
  
  def self.run(piston, direction)
    if direction != :random
      piston.change_direction(direction)
    else
      piston.change_direction Piston::DIRECTIONS.sample
    end
  end

  def run(piston)
    self.class.run(piston, DIRECTIONS[value[:value] % DIRECTIONS.size])
  end

  
  def info
    # Table with headings
    table = super
    table << ["direction", "#{DIRECTIONS[value[:value] % DIRECTIONS.size]}"]
    table
  end
end