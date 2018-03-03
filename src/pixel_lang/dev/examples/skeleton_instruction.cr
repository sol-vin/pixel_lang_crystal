require "../../12_instruction_meta"

class IMeta < InstructionMeta

  def self.reference_card
    %q{
    IMGet Instruction
    Gets the color of the location at X, Y, and puts it into i stack, CC then CV.
    0bCCCCMM000000000000000000
    C = Control Code (Instruction) [4 bits]
    M = Meta Instruction           [2 bits]
    }
  end

  def self.meta_code
    0x3
  end

  def self.make_color()
    ((control_code << C24::CONTROL_CODE_BITSHIFT) + (meta_code << C24::META_CODE_BITSHIFT)).to_s 16
  end

  def self.make()
    self.new(C24.new(make_color().to_i 16))
  end

  def self.run()
  end

  def initialize(value : C24)
    super value
  end

  def run(piston)
    self.class.run()
  end

  def info
    # Table with headings
    table = super
    # table << ["row1", "row2"]
    table
  end
end
