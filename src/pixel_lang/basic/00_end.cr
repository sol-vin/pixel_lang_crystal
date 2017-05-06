require './../instruction'
require './../piston'

class End < Instruction
  def self.control_code
    0x0
  end

  def self.reference_card
    puts %q{
    End Instruction
    Ends the piston
    0bCCCC00000000000000000000
    C = Control Code (Instruction) [4 bits]
    0 = Free bit [20 bits]
    }
end

  def self.make_color(priority)
    priority %= C20::MAX
    ((control_code << CONTROL_CODE_BITSHIFT) + priority).to_s 16
  end

  def self.run(piston)
    piston.kill
  end
end