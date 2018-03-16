require "./../../../basic/02_pause"

class Pause
  def self.reference_card
    %q{
    Pause Instruction
    Tells a piston to wait for Time + 1 cycles.
    0bCCCCTTTTTTTTTTTTTTTTTTTT
    C = Control Code (Instruction) [4 bits]
    T = Time (Cycles to wait) [20 bits]
    }
  end

  def self.make_color(cycles)
    if cycles >= C20::MAX
      raise "Cycles #{cycles.to_s 16} cannot be higher than #{C20::MAX} or #{C20::MAX.to_s 16}"
    end

    ((control_code << C24::CONTROL_CODE_BITSHIFT) + cycles).to_s 16
  end

  def self.make(cycles = 0x0)
    self.new(C24.new(make_color(cycles).to_i 16))
  end

  def arguments
    ["#{value[:value]}"]
  end
end