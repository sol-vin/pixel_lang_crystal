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

  def run(piston)
    s = Piston::REGISTERS[value[:s]]
    d = Piston::REGISTERS[value[:d]]
    swap = !(value[:swap] == 0)
    reverse = !(value[:reverse] == 0)
    
    self.class.run(piston, s, value[:sop], d, value[:dop], swap, reverse)
  end
end