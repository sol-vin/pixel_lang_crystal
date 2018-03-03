require "./../../../basic/08_insert"

class Insert
  def self.reference_card
    %q{
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

  def self.make(value)
    self.new(C24.new(make_color(value).to_i 16))
  end
end