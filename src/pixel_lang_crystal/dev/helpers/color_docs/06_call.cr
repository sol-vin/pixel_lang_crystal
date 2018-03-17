require "./../../../basic/06_call"

class Call
  def self.reference_card
    %q{
    Call Instruction
    Jumps a piston to a nearby instruction by the offset coordinates.    
    If x is 0 and y is 0, the frame will be added to the call stack, and
    then moved one space to prevent infinite looping.
    0bCCCCRAXWWWWWWWWYZZZZZZZZ
    C = Control Code (Instruction) [4 bits]
    A = Action [1 bit] Should this instruction manipulate the call stack?
    X = X Sign [1 bit] Deterimines if X is negative or not
    W = X [8 bits] Number of X spaces to jump
    Y = Y Sign [1 bit] Deterimines if Y is negative or not
    Z = Y [8 bits] Number of Y spaces to jump
    }
  end

  def self.make_color(action : Symbol, x : Int, y : Int)
    x_sign = ((x < 0) ? 1 : 0)
    y_sign = ((y < 0) ? 1 : 0)

    x = x.abs
    y = y.abs

    ((control_code << C24::CONTROL_CODE_BITSHIFT) +
      ((ACTIONS.index(action).as(Int32)) << ACTION_BITSHIFT) + 
      (x_sign << X_SIGN_BITSHIFT) + (x << X_BITSHIFT) +
      (y_sign << Y_SIGN_BITSHIFT) + (y << Y_BITSHIFT)).to_s 16
  end

  def self.make(action : Symbol, x : Int, y : Int)
    self.new(C24.new(make_color(action, x, y).to_i 16))
  end
  def arguments
    [":#{ACTIONS[value[:action]]}", "#{value[:x]}", "#{value[:y]}"]
  end
end