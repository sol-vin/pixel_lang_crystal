require "./../../../basic/07_return"

class Return
  def self.reference_card
    %q{
    Return Instruction
    Returns a frame from the call stack.
    0bCCCC00000000PPABSIIMMXYD
    C = Control Code (Instruction) [4 bits]
    P = Action bits [:pop, :peek, :pop_push, :peek_push]
    A = Copy MA?
    B = Copy MB?
    S = Copy S?
    I = Copy I action? [:keep, :restore, :clear]
    M = Copy memory action? [:keep, :restore, :clear]
    X = Jump back to X?
    Y = Jump back to Y?
    D = Change the direction?
    0 = Free bit                   [8 bits]
    }
  end

  def self.make_color(action : Symbol, 
                      ma : Bool, 
                      mb : Bool, 
                      s : Bool, 
                      i : Symbol, 
                      memory : Symbol, 
                      x : Bool, 
                      y : Bool, 
                      direction : Bool)
    action = ACTIONS.index(action).as(Int32) << ACTION_BITSHIFT
    ma = (ma ? Constants::TRUE : Constants::FALSE) << MA_BITSHIFT
    mb = (mb ? Constants::TRUE : Constants::FALSE) << MB_BITSHIFT
    s = (s ? Constants::TRUE : Constants::FALSE) << S_BITSHIFT
    i = I_ACTIONS.index(i).as(Int32) << I_BITSHIFT
    memory = MEMORY_ACTIONS.index(memory).as(Int32) << MEMORY_BITSHIFT
    x = (x ? Constants::TRUE : Constants::FALSE) << X_BITSHIFT
    y = (y ? Constants::TRUE : Constants::FALSE) << Y_BITSHIFT
    direction = (direction ? Constants::TRUE : Constants::FALSE) << DIRECTION_BITSHIFT
    
    ((control_code << C24::CONTROL_CODE_BITSHIFT) + action + ma + mb + s + i + memory + x + y + direction).to_s 16
  end

  def self.make(action, ma, mb, s, i, memory, x, y, direction)
    self.new(C24.new(make_color(action, ma, mb, s, i, memory, x, y, direction).to_i 16))
  end

  def arguments
    action = ":#{ACTIONS[value[:action]]}"
    ma = "#{value[:ma] == Constants::TRUE}"
    mb = "#{value[:mb] == Constants::TRUE}"
    s = "#{value[:s] == Constants::TRUE}"
    i = ":#{I_ACTIONS[value[:i]]}"
    memory = "#{MEMORY_ACTIONS[value[:memory]]}"
    x = "#{value[:x] == Constants::TRUE}"
    y = "#{value[:y] == Constants::TRUE}"
    direction = "#{value[:direction] == Constants::TRUE}"
    [action, ma, mb, s, i, memory, x, y, direction]
  end
end