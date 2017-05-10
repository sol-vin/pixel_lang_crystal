require "./../instruction"
require "./../piston"

class Pause < Instruction
  def self.control_code
    0x2
  end
  
  def self.reference_card
    puts %q{
    Pause Instruction
    Tells a piston to wait for Time + 1 cycles.
    0bCCCCTTTTTTTTTTTTTTTTTTTT
    C = Control Code (Instruction) [4 bits]
    T = Time (Cycles to wait) [20 bits]
    }
  end

  def self.make_color(cycles)
    if cycles > COLOR_VALUE_BITMASK
      raise "Cycles #{cycles.to_s 16} cannot be higher than #{COLOR_VALUE_BITMASK} or #{COLOR_VALUE_BITMASK.to_s 16}"
    end

    ((control_code <<C24::CONTROL_CODE_BITSHIFT) + cycles).to_s 16
  end

  def self.run(piston, cycles)
    piston.pause cycles
  end
  
  def run(piston)
    self.class.run(piston, value[:value])
  end
end