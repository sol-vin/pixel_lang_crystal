require "./instruction"
require "./piston"

abstract class MetaInstruction < Instruction
  def self.meta_code
    -1
  end

  def self.match(other : C24)
    super && meta_code == other[:meta_code]
  end
end