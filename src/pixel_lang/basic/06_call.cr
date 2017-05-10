require "./../instruction"
require "./../piston"

class Call < Instruction
  def self.control_code
    0x6
  end

  X_SIGN_BITS = 1
  X_SIGN_BITSHIFT = 19

  X_BITS = 9
  X_BITSHIFT = 10

  Y_SIGN_BITS = 1
  Y_SIGN_BITSHIFT = 9

  Y_BITS = 9
  Y_BITSHIFT = 0

  def self.reference_card
    puts %q{
    Call Instruction
    Jumps a piston to a nearby instruction by the offset coordinates.
    0bCCCCXWWWWWWWWWYZZZZZZZZZ
    C = Control Code (Instruction) [4 bits]
    X = X Sign [1 bit] Deterimines if X is negative or not
    W = X [9 bits] Number of X spaces to jump
    Y = Y Sign [1 bit] Deterimines if Y is negative or not
    Z = Y [9 bits] Number of Y spaces to jump
    }
  end

  def self.make_color(x, y)
    x_sign = ((x < 0) ? 1 : 0)
    y_sign = ((y < 0) ? 1 : 0)

    x = x.abs
    y = y.abs

    ((control_code <<C24::CONTROL_CODE_BITSHIFT) +
      (x_sign << X_SIGN_BITSHIFT) + (x << X_BITSHIFT) +
      (y_sign << Y_SIGN_BITSHIFT) + (y << Y_BITSHIFT)).to_s 16
  end

  def self.make(x, y)
    Call.new(C24.new(make_color(x, y).to_i 16))
  end

  def self.run(piston, x, y)
    piston.call(x, y)
  end

  def initialize(value : C24)
    super value
    @value.add_mask(:x_sign, X_SIGN_BITS, X_SIGN_BITSHIFT)
    @value.add_mask(:x, X_BITS, X_BITSHIFT)
    @value.add_mask(:y_sign, Y_SIGN_BITS, Y_SIGN_BITSHIFT)
    @value.add_mask(:y, Y_BITS, Y_BITSHIFT)
  end

  def run(piston)
    x = ((value[:x_sign] == 0) ? value[:x] : -(value[:x].to_i32))
    y = ((value[:y_sign] == 0) ? value[:y] : -(value[:y].to_i32))
    
    self.class.run(piston, x, y)
  end

  def show_info
    # Table with headings
    table = TerminalTable.new
    table.headings = ["#{self.class}\n------\nName", "#{value[:value].to_s(16)}\n------\nValue"]
    table.separate_rows = true
    table << ["x", "#{((value[:x_sign] == 0) ? value[:x] : -(value[:x].to_i32))}"]
    table << ["y", "#{((value[:y_sign] == 0) ? value[:y] : -(value[:y].to_i32))}"]
    table.render
  end
end