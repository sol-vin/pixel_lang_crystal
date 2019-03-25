require "../../13_instruction_meta"

class IMetaSet < InstructionMeta
  X_REGISTER_BITS = 3
  X_REGISTER_BITSHIFT = 15

  X_REGISTER_OPTIONS_BITS = 2
  X_REGISTER_OPTIONS_BITSHIFT = 13

  Y_REGISTER_BITS = 3
  Y_REGISTER_BITSHIFT = 10

  Y_REGISTER_OPTIONS_BITS = 2
  Y_REGISTER_OPTIONS_BITSHIFT = 8

  I_OPTIONS_BITS = 2
  I_OPTIONS_BITSHIFT = 6

  CC_REGISTER_BITS = 3
  CC_REGISTER_BITSHIFT = 3

  CC_REGISTER_OPTIONS_BITS = 2
  CC_REGISTER_OPTIONS_BITSHIFT = 1

  def self.meta_code
    0x1
  end

  def self.run(piston, x, xop, y, yop, iop, cc, ccop)
    x_value = piston.get(x, xop).value
    y_value = piston.get(y, yop).value
    color = C24.new(0)
    color[:control_code] = piston.get(cc, ccop).value.to_u32
    color[:value] = piston.get_i(iop).value.to_u32
    i = Instruction.find_instruction(color).new(color)
    piston.engine.instructions[x_value, y_value] = i
  end

  def initialize(value : C24)
    super value
    @value.add_mask(:x, X_REGISTER_BITS, X_REGISTER_BITSHIFT)
    @value.add_mask(:xop, X_REGISTER_OPTIONS_BITS, X_REGISTER_OPTIONS_BITSHIFT)

    @value.add_mask(:y, Y_REGISTER_BITS, Y_REGISTER_BITSHIFT)
    @value.add_mask(:yop, Y_REGISTER_OPTIONS_BITS, Y_REGISTER_OPTIONS_BITSHIFT)
    @value.add_mask(:iop, I_OPTIONS_BITS, I_OPTIONS_BITSHIFT)
    @value.add_mask(:cc, CC_REGISTER_BITS, CC_REGISTER_BITSHIFT)
    @value.add_mask(:ccop, CC_REGISTER_OPTIONS_BITS, CC_REGISTER_OPTIONS_BITSHIFT)
  end

  def run(piston)
    x = Piston::REGISTERS[value[:x]]
    y = Piston::REGISTERS[value[:y]]
    cc = Piston::REGISTERS[value[:cc]]
    self.class.run(piston, x, value[:xop], y, value[:xop], value[:iop], cc, value[:ccop])
  end
end
