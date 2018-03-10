require "./../instruction"
require "./../piston"

class Jump < Instruction
  def self.control_code
    0x5
  end

  def self.run(piston, spaces)
    piston.move spaces
  end

  def run(piston)
    self.class.run(piston, value[:value]+1)
  end
end