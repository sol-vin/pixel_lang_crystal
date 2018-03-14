require "./../instruction"
require "./../piston"

class Call < Instruction
  def self.control_code
    0x6
  end

  ACTION_BITS = 2
  ACTION_BITSHIFT = 18

  X_SIGN_BITS = 1
  X_SIGN_BITSHIFT = 17

  X_BITS = 8
  X_BITSHIFT = 9

  Y_SIGN_BITS = 1
  Y_SIGN_BITSHIFT = 8

  Y_BITS = 8
  Y_BITSHIFT = 0

  def self.run(piston, action, x, y)
    piston.call(x, y, action)
  end

  def initialize(value : C24)
    super
    @value.add_mask(:action, ACTION_BITS, ACTION_BITSHIFT)        
    @value.add_mask(:x_sign, X_SIGN_BITS, X_SIGN_BITSHIFT)
    @value.add_mask(:x, X_BITS, X_BITSHIFT)
    @value.add_mask(:y_sign, Y_SIGN_BITS, Y_SIGN_BITSHIFT)
    @value.add_mask(:y, Y_BITS, Y_BITSHIFT)
  end

  def run(piston)
    x = ((value[:x_sign] == 0) ? value[:x] : -(value[:x].to_i32))
    y = ((value[:y_sign] == 0) ? value[:y] : -(value[:y].to_i32))
    
    self.class.run(piston, (value[:action] == 1), x, y)
  end
end