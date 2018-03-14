class Return < Instruction
  def self.control_code
    0x7
  end
  # pop, pop the call frame
  # peek, don't pop the call frame
  # pop_push, pop the call frame, push our current state back on
  # peek_push, don't pop the frame and push our current frame back on.
  ACTIONS = [:pop, :peek, :pop_push, :peek_push]
  ACTION_BITS = 2
  ACTION_BITSHIFT = 10

  MA_BITS = 1
  MA_BITSHIFT = 9

  MB_BITS = 1
  MB_BITSHIFT = 8

  S_BITS = 1
  S_BITSHIFT = 7

  I_ACTIONS = [:keep, :restore, :clear]
  I_BITS = 2
  I_BITSHIFT = 5

  MEMORY_ACTIONS = [:keep, :restore, :clear]  
  MEMORY_BITS = 2
  MEMORY_BITSHIFT = 3

  X_BITS = 1
  X_BITSHIFT = 2

  Y_BITS = 1
  Y_BITSHIFT = 1

  DIRECTION_BITS = 1
  DIRECTION_BITSHIFT = 0

  def self.run(piston, action, ma, mb, s, i, memory, x, y, direction)
    piston.return_call(action, ma, mb, s, i, memory, x, y, direction)
  end

  def initialize(value : C24)
    super value
    @value.add_mask(:action, ACTION_BITS, ACTION_BITSHIFT)
    @value.add_mask(:ma, MA_BITS, MA_BITSHIFT)
    @value.add_mask(:mb, MB_BITS, MB_BITSHIFT)
    @value.add_mask(:s, S_BITS, S_BITSHIFT)
    @value.add_mask(:i, I_BITS, I_BITSHIFT)
    @value.add_mask(:memory, MEMORY_BITS, MEMORY_BITSHIFT)
    @value.add_mask(:x, X_BITS, X_BITSHIFT)
    @value.add_mask(:y, Y_BITS, Y_BITSHIFT)
    @value.add_mask(:direction, DIRECTION_BITS, DIRECTION_BITSHIFT)
  end

  def run(piston)
    action = ACTIONS[value[:action]]
    ma = (value[:ma] == Constants::TRUE)
    mb = (value[:mb] == Constants::TRUE)
    s = (value[:s] == Constants::TRUE)
    i = I_ACTIONS[value[:i]]
    memory = MEMORY_ACTIONS[value[:s]]
    x = (value[:x] == Constants::TRUE)
    y = (value[:y] == Constants::TRUE)
    direction = (value[:direction] == Constants::TRUE)
    self.class.run(piston, action, ma, mb, s, i, memory, x, y, direction)
  end
end
