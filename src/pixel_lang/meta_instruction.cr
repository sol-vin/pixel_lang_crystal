require "./../instruction"
require "./../piston"

abstract class MetaInstruction < Instruction
  def self.meta_code
    -1
  end

  def self.match(other : C24)
    super && meta_code == other[:meta_code]
  end

  def info
    # Table with headings
    table = super
    table << ["meta_code", value[:meta_code].to_s]
    table
  end
end