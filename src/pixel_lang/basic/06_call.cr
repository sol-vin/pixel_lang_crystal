require "./../instruction"
require "./../piston"

class Call < Instruction
  def self.control_code
    0x6
  end
  
  RETURN_BITS = 1
  RETURN_BITSHIFT = 19

  ACTION_BITS = 1
  ACTION_BITSHIFT = 18

  X_SIGN_BITS = 1
  X_SIGN_BITSHIFT = 17

  X_BITS = 8
  X_BITSHIFT = 9

  Y_SIGN_BITS = 1
  Y_SIGN_BITSHIFT = 8

  Y_BITS = 8
  Y_BITSHIFT = 0

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
    Call.new(C24.new(make_color(is_return, action, x, y).to_i 16))
  end

  def self.run(piston, is_return, action, x, y)
    if is_return
      piston.return_call(action)
    else
      piston.call(x, y, action)
    end
  end

  def initialize(value : C24)
    super value
    @value.add_mask(:return, RETURN_BITS, RETURN_BITSHIFT)
    @value.add_mask(:action, ACTION_BITS, ACTION_BITSHIFT)        
    @value.add_mask(:x_sign, X_SIGN_BITS, X_SIGN_BITSHIFT)
    @value.add_mask(:x, X_BITS, X_BITSHIFT)
    @value.add_mask(:y_sign, Y_SIGN_BITS, Y_SIGN_BITSHIFT)
    @value.add_mask(:y, Y_BITS, Y_BITSHIFT)
  end

  def run(piston)
    x = ((value[:x_sign] == 0) ? value[:x] : -(value[:x].to_i32))
    y = ((value[:y_sign] == 0) ? value[:y] : -(value[:y].to_i32))
    
    self.class.run(piston, (value[:return] == 1), (value[:action] == 1), x, y)
  end

  def info
    # Table with headings
    table = super
    table << ["return", "#{value[:return] == 1}"]
    table << ["action", "#{value[:action] == 1}"]
    table << ["x", "#{((value[:x_sign] == 0) ? value[:x] : -(value[:x].to_i32))}"]
    table << ["y", "#{((value[:y_sign] == 0) ? value[:y] : -(value[:y].to_i32))}"]
    table
  end
end