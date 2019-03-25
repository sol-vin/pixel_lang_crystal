require "./../../../../basic/13_instruction_meta/01_set"

class IMetaSet
  def self.reference_card
    %q{
    IMetaSet Instruction
    Sets the color of the location at X, Y, reads color from i stack, CV then CC.
    0bCCCCMMXXX11YYY11II000000
    C = Control Code (Instruction) [4 bits]
    M = Meta Instruction           [2 bits]
    X = X coord register           [3 bits]
    1 = X register options         [2 bits]
    Y = Y coord register           [3 bits]
    2 = Y register options         [2 bits]
    I = I Register Options         [2 bits]
    }
  end

  def self.make_color(x, xop, y, yop, iop, cc, ccop)
    x = Piston::REGISTERS.index(x).as(Int32) << X_REGISTER_BITSHIFT
    xop <<= X_REGISTER_OPTIONS_BITSHIFT
    y = Piston::REGISTERS.index(y).as(Int32) << Y_REGISTER_BITSHIFT
    yop <<= Y_REGISTER_OPTIONS_BITSHIFT
    iop <<= I_OPTIONS_BITSHIFT

    cc = Piston::REGISTERS.index(cc).as(Int32) << CC_REGISTER_BITSHIFT
    ccop <<= CC_REGISTER_OPTIONS_BITSHIFT
    ((control_code << C24::CONTROL_CODE_BITSHIFT) + (meta_code << C24::META_CODE_BITSHIFT) + x + xop + y + yop + iop + cc + ccop).to_s 16
  end

  def self.make(x, xop, y, yop, iop, cc, ccop)
    self.new(C24.new(make_color(x, xop, y, yop, iop, cc, ccop).to_i 16))
  end
end