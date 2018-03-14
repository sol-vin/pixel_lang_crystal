require "../../13_instruction_meta/03_property"
class IMetaProperty
  def self.reference_card
    %q{
    IMetaValue Instruction
    Gets the color of the location at X, Y, and puts it into i stack, CC then CV.
    0bCCCCMM000000000000000000
    C = Control Code (Instruction) [4 bits]
    M = Meta Instruction           [2 bits]
    }
  end

  def self.make_color(a_property)
    ((control_code << C24::CONTROL_CODE_BITSHIFT) + (meta_code << C24::META_CODE_BITSHIFT) + PROPERTIES.index(a_property).as(Int32)).to_s 16
  end

  def self.make(a_property)
    self.new(C24.new(make_color(a_property).to_i 16))
  end
end
