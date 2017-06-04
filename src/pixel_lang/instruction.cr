require "./c24"

# Class that holds a class-level list of children, matches C24 to those children.
# Instance that holds a C24 and provides bitmasking for values, as well as how the instruction will run.
abstract class Instruction
  # Class level variable for holding children who inherit this class.
  @@instructions = [] of self.class
  
  # A list of instruction classes.
  def self.instructions
    @@instructions
  end

  # Finds the appropriate instruction and provides the class as a base Instruction.
  def self.find_instruction(c24)
    i = instructions.find {|i| i.match c24 }
    if i.nil?
      raise "INSTRUCTION NOT FOUND #{c24.to_int_hex}"
    end
    i.as(Instruction.class)
  end

  # Runs the instruction on a reading piston.
  def self.run(piston)
  end
  
  # When inherited, put that child class into the list.
  macro inherited
    Instruction.instructions << {{@type}}
  end

  # Control code for the instruction. (The first digit in it's hex code.)
  def self.control_code : Int32
    -1 # So it won't match anything.'
  end

  # Does the incoming C24 match our instruction's pattern? This rarely needs to be overridden.
  def self.match(c24 : C24) : Bool
    control_code == c24[:control_code]
  end

  # The internal value of the instruction.
  getter value : C24

  def initialize(@value : C24)
  end

  # Runs this instruction. This method signature must not change when adding new instructions.
  def run(piston)
    self.class.run(piston)
  end

  def info
    table = [] of Array(String)
    table << ["#{self.class}(#{self.class.control_code})\n------\nName", "#{value[:value].to_s(16)}\n------\nValue"]
    table
  end
end