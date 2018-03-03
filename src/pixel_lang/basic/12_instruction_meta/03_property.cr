require "../../12_instruction_meta"

class IMetaProperty < InstructionMeta
  PROPERTIES = [:width, :height]
  PROPERTY_BITS = 18
  PROPERTY_BITSHIFT = 0

  def self.reference_card
    %q{
    IMetaValue Instruction
    Gets the color of the location at X, Y, and puts it into i stack, CC then CV.
    0bCCCCMM000000000000000000
    C = Control Code (Instruction) [4 bits]
    M = Meta Instruction           [2 bits]
    }
  end

  def self.meta_code
    0x3
  end

  def self.make_color(a_property)
    ((control_code << C24::CONTROL_CODE_BITSHIFT) + (meta_code << C24::META_CODE_BITSHIFT) + PROPERTIES.index(a_property).as(Int32)).to_s 16
  end

  def self.make(a_property)
    self.new(C24.new(make_color(a_property).to_i 16))
  end

  def self.run(piston, a_property)
    case a_property
      when :width
        piston.set_i C20.new(piston.engine.instructions.width), 0
      when :height
        piston.set_i C20.new(piston.engine.instructions.height), 0
    end
  end

  def initialize(value : C24)
    super value
    @value.add_mask(:property, PROPERTY_BITS, PROPERTY_BITSHIFT)
  end

  def run(piston)
    self.class.run(piston, PROPERTIES[value[:property]])
  end

  def info
    # Table with headings
    table = super
    # table << ["row1", "row2"]
    table
  end
end
