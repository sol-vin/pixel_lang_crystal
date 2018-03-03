require "./../instruction"
require "./../piston"

class End < Instruction
  def self.control_code
    0x0
  end

  def self.run(piston)
    piston.kill
  end
end