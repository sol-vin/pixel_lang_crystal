require './../instruction'
require './../piston'

class Move < Instruction
  def self.control_code
    0x9
  end

  SOURCE_BITS = 3
  SOURCE_BITSHIFT = 17

  SOURCE_OPTIONS_BITS = 2
  SOURCE_OPTIONS_BITSHIFT = 15


  DESTINATION_BITS = 3
  DESTINATION_BITSHIFT = 12

  DESTINATION_OPTIONS_BITS = 2
  DESTINATION_OPTIONS_BITSHIFT = 10

  SWAP_BITS = 1
  SWAP_BITSHIFT = 9

  REVERSE_BITS = 1
  REVERSE_BITSHIFT = 8

  def self.reference_card
    puts %q{
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

    sop <<= SOURCE_OPTIONS_BITSHIFT
    dop <<= DESTINATION_OPTIONS_BITSHIFT

    s = Piston::REGISTERS.index(s) << SOURCE_BITSHIFT

    d = Piston::REGISTERS.index(d) << DESTINATION_BITSHIFT


    swap = (swap ? C20::TRUE : C20::FALSE) << SWAP_BITSHIFT
    reverse = (reverse ? C20::TRUE : C20::FALSE) << REVERSE_BITSHIFT


    ((cc << CONTROL_CODE_BITSHIFT) + s + sop + d + dop + swap + reverse).to_s 16
  end

  def self.run(piston : Piston, s : Symbol, sop : Int, d : Symbol, dop : Int, swap = false, reverse = false)
    s, d = d, s if reverse

    if swap
      cs = piston.get(s, sop)
      cd = piston.get(d, dop)
      piston.set(s, cd, sop)
      piston.set(d, cs, dop)
    else
      piston.set(d, piston.get(s, sop), dop)
    end
  end

  def run(piston)
    s = Piston::REGISTERS.index(value[:s])
    d = Piston::REGISTERS.index(value[:d])
    swap = !value[:swap].zero?
    reverse = !value[:reverse].zero?
    
    self.class.run(piston, s, value[:sop], d, value[:dop], swap, reverse)
  end
end  