require "./c24"

abstract class Instruction
  @@instructions = [] of self.class

  def self.instructions
    @@instructions
  end

  def self.find_instruction(c24)
    i = instructions.find {|i| i.match c24 }
    if i.nil?
      raise "INSTRUCTION NOT FOUND #{c24.to_int_hex}"
    end
    i.as(Instruction.class)
  end

  def self.run(piston)
  end
  
  macro inherited
    Instruction.instructions << {{@type}}
  end

  def self.control_code : Int32
    -1
  end

  def self.match(c24 : C24) : Bool
    control_code == c24[:control_code]
  end

  getter value : C24

  def initialize(@value : C24)
  end

  abstract def char : Char

  def run(piston)
    self.class.run(piston)
  end

  def show_info
    # Table with headings
    table = TerminalTable.new
    table.headings = ["#{self.class}(#{self.class.control_code})\n------\nName", "#{value[:value].to_s(16)}\n------\nValue"]
    table << ["", ""]
    table.render
  end
end