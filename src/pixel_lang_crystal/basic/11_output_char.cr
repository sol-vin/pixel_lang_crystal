require "./../instruction"
require "./../piston"

class OutputChar < Instruction
  def self.control_code
    0xB
  end

  def self.run(piston, char)
    piston.engine.write_output char, :char
  end

  def run(piston)
    self.class.run(piston, C20.new(value[:value] % 0x100))
  end
end