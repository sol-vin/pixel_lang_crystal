require "./../../../basic/11_output_char"

class OutputChar
  def self.reference_card
    %q{
    OutputChar Instruction
    Sends a char straight to engine.write_output
    0bCCCCSSSSSSSSSSSSSSSSSSSS
    C = Control Code (Instruction) [4 bits]
    S = Char [20 bits] A char, will be % by 0x100
    }
  end

  def self.make_color(char)
    ((control_code << C24::CONTROL_CODE_BITSHIFT) + char.ord).to_s 16
  end

  def self.make(char)
    self.new(C24.new(make_color(char).to_i 16))
  end

  def arguments
    ["\'#{(value[:value] % 255).chr}\'"]
  end
end