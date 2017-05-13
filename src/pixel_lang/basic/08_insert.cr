require "./../instruction"
require "./../piston"

class Insert < Instruction
  def self.control_code
    0x8
  end

  def self.reference_card
    puts %q{
    Insert Instruction
    Inserts the color value into register i
    0bCCCCVVVVVVVVVVVVVVVVVVVV
    C = Control Code (Instruction) [4 bits]
    V = Value [20 bits]
    }
  end

  def self.make_color(value : Int)
    ((control_code <<C24::CONTROL_CODE_BITSHIFT) + value % (C20::MAX)).to_s 16
  end

  def self.run(piston, number)
    piston.set_i number, 0
  end

  def char : Char
    '\u24BE'
  end

  def run(piston)
    self.class.run(piston, C20.new(value[:value]))
  end
end