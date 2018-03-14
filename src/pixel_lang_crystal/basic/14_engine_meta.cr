require "./../meta_instruction"

abstract class EngineMeta < MetaInstruction
  def self.control_code
    0xE
  end
end

