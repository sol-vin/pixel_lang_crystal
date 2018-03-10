require "./../instruction"
require "./../piston"

class Pause < Instruction
  def self.control_code
    0x2
  end

  def self.run(piston, cycles)
    piston.pause cycles
  end
  
  def run(piston)
    self.class.run(piston, value[:value])
  end
end