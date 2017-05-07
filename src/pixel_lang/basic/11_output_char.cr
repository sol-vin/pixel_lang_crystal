require "./../instruction"
require "./../piston"

class OutputChar < Instruction
  def self.control_code
    0xB
  end

  def self.reference_card
    puts %q{
    OutputChar Instruction
    Sends a char straight to engine.write_output
    0bCCCCSSSSSSSSSSSSSSSSSSSS
    C = Control Code (Instruction) [4 bits]
    S = Char [20 bits] A char, will be % by 0x100
    }
  end

  def self.make_color(char)
    ((control_code << CONTROL_CODE_BITSHIFT) + char.ord).to_s 16
  end

  def run(piston)
    self.class.run(piston, cv)
  end

  def self.run(piston, *args)
    piston.parent.write_output (args[0]%0x100).chr
  end
end