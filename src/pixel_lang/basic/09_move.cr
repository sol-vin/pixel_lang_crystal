require "./../instruction"
require "./../piston"

class Move < Instruction
  def self.control_code
    0x9
  end

  SOURCE_BITS = 3
  SOURCE_BITSHIFT = 17

  SOURCE_OPTION_BITS = 2
  SOURCE_OPTION_BITSHIFT = 15


  DESTINATION_BITS = 3
  DESTINATION_BITSHIFT = 12

  DESTINATION_OPTION_BITS = 2
  DESTINATION_OPTION_BITSHIFT = 10

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

    sop <<= SOURCE_OPTION_BITSHIFT
    dop <<= DESTINATION_OPTION_BITSHIFT

    s = Piston::REGISTERS.index(s).as(Int32) << SOURCE_BITSHIFT

    d = Piston::REGISTERS.index(d).as(Int32) << DESTINATION_BITSHIFT


    swap = (swap ? Constants::TRUE : Constants::FALSE) << SWAP_BITSHIFT
    reverse = (reverse ? Constants::TRUE : Constants::FALSE) << REVERSE_BITSHIFT


    ((control_code << C24::CONTROL_CODE_BITSHIFT) + s + sop + d + dop + swap + reverse).to_s 16
  end

  def self.make(s, sop, d, dop, swap = false, reverse = false)
    Move.new(C24.new(make_color(s, sop, d, dop, swap, reverse).to_i 16))
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

  def initialize(value : C24)
    super value
    @value.add_mask(:s, SOURCE_BITS, SOURCE_BITSHIFT)
    @value.add_mask(:sop, SOURCE_OPTION_BITS, SOURCE_OPTION_BITSHIFT)
    @value.add_mask(:d, DESTINATION_BITS, DESTINATION_BITSHIFT)
    @value.add_mask(:dop, DESTINATION_OPTION_BITS, DESTINATION_OPTION_BITSHIFT)
    @value.add_mask(:swap, SWAP_BITS, SWAP_BITSHIFT)
    @value.add_mask(:reverse, REVERSE_BITS, REVERSE_BITSHIFT)        
  end

  def char : Char
    '\u2386'
  end

  def run(piston)
    s = Piston::REGISTERS[value[:s]]
    d = Piston::REGISTERS[value[:d]]
    swap = !(value[:swap] == 0)
    reverse = !(value[:reverse] == 0)
    
    self.class.run(piston, s, value[:sop], d, value[:dop], swap, reverse)
  end

  def show_info
    # Table with headings
    table = TerminalTable.new
    table.headings = ["#{self.class}\n------\nName", "#{value[:value].to_s(16)}\n------\nValue"]
    table << ["s", Piston::REGISTERS[value[:s]].to_s]
    table << ["sop", value[:sop]]
    table << ["d", Piston::REGISTERS[value[:d]].to_s]
    table << ["dop", value[:dop]] 
    table.render
  end
end  