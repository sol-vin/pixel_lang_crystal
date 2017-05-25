require "./../instruction"
require "./../piston"

class OutputChar < Instruction
  def self.control_code
    0xB
  end

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

  def self.run(piston, char)
    piston.engine.write_output char, :char
  end

  def run(piston)
    self.class.run(piston, C20.new(value[:value] % 0x100))
  end

  def info
    # Table with headings
    table = super
    table << ["char", (value[:value] % 0x100).chr.to_s]
    table
  end
end