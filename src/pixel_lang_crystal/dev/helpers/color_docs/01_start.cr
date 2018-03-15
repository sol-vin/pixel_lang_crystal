require "./../../../basic/01_start"

class Start

  def self.reference_card
    %q{
    Start Instruction
    Tell the engine where to place a piston, what direction it should face, and what it's priority should be.
    0bCCCCDDPPPPPPPPPPPPPPPPPP
    C = Control Code (Instruction) [4 bits]
    D = Direction [2 bits] Direction where the piston should go
    P = Priority [18 bits] Order in which piston should run their cycles. 0 goes first.
    }
  end

  def self.make_color(direction, priority = 0)
    direction_bits = Constants::BASIC_DIRECTIONS.index(direction).as(Int32) << DIRECTION_BITSHIFT

    ((control_code << C24::CONTROL_CODE_BITSHIFT) + direction_bits + priority).to_s 16
  end

  def self.make(direction, priority = 0)
    self.new(C24.new(make_color(direction, priority).to_i 16))
  end

  def arguments
    [":#{Constants::BASIC_DIRECTIONS[value[:direction]]}", "#{value[:priority]}"]
  end
end