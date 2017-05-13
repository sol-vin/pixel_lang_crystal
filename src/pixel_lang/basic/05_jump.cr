require "./../instruction"
require "./../piston"

class Jump < Instruction
  def self.control_code
    0x5
  end

  def self.reference_card
    puts %q{
    Jump Instruction
    Piston jumps spaces+1 in the direction it's facing
    0bCCCCSSSSSSSSSSSSSSSSSSSS
    C = Control Code (Instruction) [4 bits]
    S = Spaces [20 bits] number of space beyond the first to jump
    }
  end

  def self.make_color(spaces)
    ((control_code << C24::CONTROL_CODE_BITSHIFT) + spaces).to_s 16
  end

  def self.run(piston, spaces)
    piston.move spaces
  end

  def char : Char
    'J'
  end

  def run(piston)
    self.class.run(piston, value[:value]+1)
  end
end