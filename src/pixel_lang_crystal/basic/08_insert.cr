require "./../instruction"
require "./../piston"

class Insert < Instruction
  def self.control_code
    0x8
  end

  def self.run(piston, number)
    piston.set_i number, 0
  end

  def run(piston)
    self.class.run(piston, C20.new(value[:value]))
  end
end