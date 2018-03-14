require "../../13_instruction_meta"

class IMetaProperty < InstructionMeta
  PROPERTIES = [:width, :height]
  PROPERTY_BITS = 18
  PROPERTY_BITSHIFT = 0

  
  def self.meta_code
    0x3
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
