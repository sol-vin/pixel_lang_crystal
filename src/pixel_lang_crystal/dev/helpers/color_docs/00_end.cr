require "./../../../basic/00_end"

class End < Instruction
  def self.reference_card
    %q{
    End Instruction
    Ends the piston
    0bCCCC00000000000000000000
    C = Control Code (Instruction) [4 bits]
    0 = Free bit [20 bits]
    }
  end

  def self.make_color(value = 0x0)
    ((control_code << C24::CONTROL_CODE_BITSHIFT) + value).to_s 16
  end

  def self.make(value = 0x0)
    self.new(C20.new(make_color(value).to_i 16))
  end

  def arguments
    ["#{value[:value]}"]
  end
end