require_relative './../instruction'
require_relative './../piston'

class Blank < Instruction
  def self.control_code : Int32
    0xF
  end
end