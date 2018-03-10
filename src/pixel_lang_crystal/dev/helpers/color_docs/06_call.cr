require "./../../../basic/06_call"

class Call
  def self.reference_card
    %q{
    Call Instruction
    Jumps a piston to a nearby instruction by the offset coordinates.
    0bCCCCRAXWWWWWWWWYZZZZZZZZ
    C = Control Code (Instruction) [4 bits]
    R = Return [1 bit] Should this call instruction return instead?
    A = Action [1 bit] Should this instruction manipulate the call stack?
    X = X Sign [1 bit] Deterimines if X is negative or not
    W = X [8 bits] Number of X spaces to jump
    Y = Y Sign [1 bit] Deterimines if Y is negative or not
    Z = Y [8 bits] Number of Y spaces to jump
    }
  end

  def self.make_color(is_return = false, action = false, x = 0, y = 0)
    x_sign = ((x < 0) ? 1 : 0)
    y_sign = ((y < 0) ? 1 : 0)

    x = x.abs
    y = y.abs

    ((control_code << C24::CONTROL_CODE_BITSHIFT) +
      ((is_return ? 1 : 0) << RETURN_BITSHIFT) + 
      ((action ? 1 : 0) << ACTION_BITSHIFT) + 
      (x_sign << X_SIGN_BITSHIFT) + (x << X_BITSHIFT) +
      (y_sign << Y_SIGN_BITSHIFT) + (y << Y_BITSHIFT)).to_s 16
  end

  def self.make(is_return, action, x, y)
    self.new(C24.new(make_color(is_return, action, x, y).to_i 16))
  end
end