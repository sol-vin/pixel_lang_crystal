require "./../../../basic/05_jump"

class Jump
  def self.reference_card
    %q{
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

  def self.make(spaces)
    self.new(C24.new(make_color(spaces).to_i 16))
  end

  def arguments
    ["#{value}"]
  end
end