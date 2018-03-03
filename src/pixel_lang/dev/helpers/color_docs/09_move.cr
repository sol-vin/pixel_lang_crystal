require "./../../../basic/09_move"

class Move
  def self.reference_card
    %q{
    Move Instruction
    Moves the contents of one register into another. Can also swap values of regular registers.
    0bCCCCSSSXXDDDYYWE00000000
    C = Control Code (Instruction) [4 bits]
    S = Source                     [3 bits]
    X = Source Options             [2 bits]
    D = Destination                [3 bits]
    Y = Destination Options        [2 bits]
    W = Swap                       [1 bit]
    R = Reverse                    [1 bit]
    0 = Free bit                   [8 bits]
    }
  end

  def self.make_color(s, sop, d, dop, swap = false, reverse = false)

    sop <<= SOURCE_OPTION_BITSHIFT
    dop <<= DESTINATION_OPTION_BITSHIFT

    s = Piston::REGISTERS.index(s).as(Int32) << SOURCE_BITSHIFT

    d = Piston::REGISTERS.index(d).as(Int32) << DESTINATION_BITSHIFT


    swap = (swap ? Constants::TRUE : Constants::FALSE) << SWAP_BITSHIFT
    reverse = (reverse ? Constants::TRUE : Constants::FALSE) << REVERSE_BITSHIFT


    ((control_code << C24::CONTROL_CODE_BITSHIFT) + s + sop + d + dop + swap + reverse).to_s 16
  end

  def self.make(s, sop, d, dop, swap = false, reverse = false)
    self.new(C24.new(make_color(s, sop, d, dop, swap, reverse).to_i 16))
  end
end