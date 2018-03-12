class Return < Instruction
  def self.control_code
    0xD
  end

  ACTION_BITS = 1
  ACTION_BITSHIFT = 9

  MA_BITS = 1
  MA_BITSHIFT = 8

  MB_BITS = 1
  MB_BITSHIFT = 7

  S_BITS = 1
  S_BITSHIFT = 6

  I_BITS = 1
  I_BITSHIFT = 5

  MEMORY_BITS = 2
  MEMORY_BITSHIFT = 3

  MEMORY_ACTIONS = [:restore, :keep, :clear]

  X_BITS = 1
  X_BITSHIFT = 2

  Y_BITS = 1
  Y_BITSHIFT = 1

  DIRECTION_BITS = 1
  DIRECTION_BITSHIFT = 2

  def self.run(piston, action, ma, mb, s, i, memory, x, y, direction)
    raise "UNIMPLEMENTED!"
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
    action = (value[:action] == Constants::TRUE)
    ma = (value[:ma] == Constants::TRUE)
    mb = (value[:mb] == Constants::TRUE)
    s = (value[:s] == Constants::TRUE)
    i = (value[:i] == Constants::TRUE)
    memory = MEMORY_ACTIONS[value[:s]]
    x = (value[:x] == Constants::TRUE)
    y = (value[:y] == Constants::TRUE)
    direction = (value[:direction] == Constants::TRUE)
    self.class.run(piston, action, ma, mb, s, i, memory, x, y, direction)
  end
end
