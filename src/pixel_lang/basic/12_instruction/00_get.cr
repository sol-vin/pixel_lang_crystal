require "../../12_instruction_meta"

class IMetaGet < InstructionMeta
  X_REGISTER_BITS = 3
  X_REGISTER_BITSHIFT = 17

  X_REGISTER_OPTIONS_BITS = 2
  X_REGISTER_OPTIONS_BITSHIFT = 15

  Y_REGISTER_BITS = 3
  Y_REGISTER_BITSHIFT = 12

  Y_REGISTER_OPTIONS_BITS = 2
  Y_REGISTER_OPTIONS_BITSHIFT = 10

  def self.reference_card
    %q{
    IMGet Instruction
    Gets the color of the location at X, Y, and puts it into i stack, CC then CV.
    0bCCCCMMXXX11YYY1100000000
    C = Control Code (Instruction) [4 bits]
    M = Meta Instruction           [2 bits]
    X = X coord register           [3 bits]
    1 = X register options         [2 bits]
    Y = Y coord register           [3 bits]
    2 = Y register options         [2 bits]
    }
  end

  def self.meta_code
    0x0
  end

  def self.make_color(x, xop, y, yop)
    x <<= X_REGISTER_BITSHIFT
    xop <<= X_REGISTER_OPTIONS_BITSHIFT
    y <<= Y_REGISTER_BITSHIFT
    yop <<= Y_REGISTER_OPTIONS_BITSHIFT

    (control_code << C24::CONTROL_CODE_BITSHIFT) + (meta_code << C24::META_CODE_BITSHIFT) + x + xop + y + yop
  end

  def self.make(x, xop, y, yop)
    IMetaGet.new(C24.new(make_color(x, xop, y, yop).to_i 16))
  end

  def self.run(piston, x, xop, y, yop)
    x_value = piston.get(x, xop)
    y_value = piston.get(y, yop)
    value = instructions[x, y].value
    piston.set_i(C20.new(value[:control_code]))
    piston.set_i(C20.new(value[:value]))
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

  def info
    # Table with headings
    table = super
    table << ["x", Piston::REGISTERS[value[:x]].to_s]
    table << ["xo", value[:xop].to_s]
    table << ["y", Piston::REGISTERS[value[:y]].to_s]
    table << ["yo", value[:yop].to_s]
    
    table
  end
end
