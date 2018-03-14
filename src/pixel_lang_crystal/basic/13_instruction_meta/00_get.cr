require "../../13_instruction_meta"

class IMetaGet < InstructionMeta
  X_REGISTER_BITS = 3
  X_REGISTER_BITSHIFT = 17

  X_REGISTER_OPTIONS_BITS = 2
  X_REGISTER_OPTIONS_BITSHIFT = 15

  Y_REGISTER_BITS = 3
  Y_REGISTER_BITSHIFT = 12

  Y_REGISTER_OPTIONS_BITS = 2
  Y_REGISTER_OPTIONS_BITSHIFT = 10

  def self.meta_code
    0x0
  end

  def self.run(piston, x, xop, y, yop)
    x_value = piston.get(x, xop).value
    y_value = piston.get(y, yop).value
    color = piston.engine.instructions[x_value, y_value]
    piston.set_i(C20.new(color.value[:control_code]), 0)
    piston.set_i(C20.new(color.value[:value]), 0)
  end

  def initialize(value : C24)
    super value
    @value.add_mask(:x, X_REGISTER_BITS, X_REGISTER_BITSHIFT)
    @value.add_mask(:xop, X_REGISTER_OPTIONS_BITS, X_REGISTER_OPTIONS_BITSHIFT)

    @value.add_mask(:y, Y_REGISTER_BITS, Y_REGISTER_BITSHIFT)
    @value.add_mask(:yop, Y_REGISTER_OPTIONS_BITS, Y_REGISTER_OPTIONS_BITSHIFT)
  end

  def run(piston)
    x = Piston::REGISTERS[value[:x]]
    y = Piston::REGISTERS[value[:y]]
    
    self.class.run(piston, x, value[:xop], y, value[:xop])
  end
end
