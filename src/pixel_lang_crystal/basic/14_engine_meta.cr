require "./../meta_instruction"

abstract class EngineMeta < MetaInstruction
  def self.control_code
    0xE
  end
end

# Holds both piston and engine meta
# Piston Meta
#   - Priority
#   - Cycles Alive
#   - # of Items on Call Stack
#   - Restore frame from call stack @ index
#   - Pop Call Stack?
#   - # of items on I stack.
#   - Peek index of I stack
#   - Take index of I stack

# Engine Meta
#   - # of Pistons
#   - Highest Prio
#   - Lowest Prio
#   - Highest Prio ID
#   - Lowest Prio ID
#   - Transfer memory
#   - Chars in input buffer
#   - Chars in output buffer
#   - Get input char @ index
#   - Get output char @ index (?)
#   - Highest ID
#   - Lowest ID
#   - Next ID
#   - Reset
#   - Reseed (Restarts the machine but doesn't clean up old pistons, input, output, starts new pistons at each start point)
#   - Kill ID
#   - Kill All


