# Base class for an Engine. 
abstract class Engine
  # Options for write_output
  OUTPUT_OPTIONS = [:int, :char, :int_hex, :char_hex]

  # Pistons currently running in this Engine.
  getter pistons : Array(Piston) = [] of Piston
  # Instructions currently loaded in the Engine.
  getter instructions : Instructions = Instructions.new(1,1)
  # Output
  getter output : String = ""
  # How many cycles this engine has run.
  getter cycles : UInt32 = 0_u32

  # Last ID given to a piston.
  getter id : UInt32 = 0_u32
  # Name of this Engine.
  getter name : String
  # How many times has this engine been run?
  getter runs : UInt32 = 0_u32
  # Memory hash
  getter memory : Hash(C20, C20) = Hash(C20,C20).new(C20.new(0))
  # Input
  getter input : String = ""
  # Last output
  getter last_output : C20 = C20.new(0)
  # Original input
  getter original_input : String = ""

  # Writes to the output stream
  abstract def write_output(item : C20, option : Symbol)
  # Takes a single char from input
  abstract def pop_char : C20
  # Peeks at a single char from input
  abstract def peek_char : C20
  # Takes a single int from input
  abstract def pop_int : C20
  # Peeks at a single int from input  
  abstract def peek_int : C20  

  #Guarantee to the compiler that this is a tuple!
  @to_merge = [] of Tuple(Piston, Piston)

  def initialize(@name : String, image_file : String, @original_input = "")
    @original_instructions = Instructions.new(image_file)
    reset # start the machine
  end

  def initialize(@name : String, @original_instructions : Instructions, @original_input = "")
    reset # start the machine
  end

  # Resets the engine to initial state
  def reset
    @id = 0_u32
    @cycles = 0_u32
    @output = ""
    @to_merge = [] of Tuple(Piston, Piston)
    @pistons = [] of Piston
    @memory = Hash(C20, C20).new(C20.new(0))
    @input = @original_input.clone
    @last_output = C20.new(0)

    @instructions = @original_instructions.dup  
    @instructions.start_points.each do |sp|
      @pistons << Piston.new(self, sp[:x], sp[:y], sp[:direction], sp[:priority])
    end
    @runs += 1
  end
  
  # Runs this engine until completion. THIS METHOD IS DANGEROUS DUE TO INFINITE LOOPS
  def run
    while step
    end
  end
  
  # Runs all the pistons once. Returns whether or not the cycle was run
  def step
    # don't run if the machine has already ended.
    return false if ended?
    # run an instruction on all pistons.
    @pistons.each(&.step)
    # merge pistons
    # pistons end up in @to_merge from fork_piston and are added
    # after instructions are ran
    @to_merge.each do |merge|
      piston_index = (pistons.index { |piston| piston.id == merge[0].id}).as(Int32)
      pistons.insert(piston_index, merge[1])
    end
    @to_merge.clear

    # prune old pistons, delete the ones that no longer are active
    @pistons.select! { |p| !p.ended? }
    @cycles += 1

    return true
  end

  # Merges a new piston into an engine. Used by Fork.
  def merge(piston, new_piston)
    @to_merge << {piston, new_piston}
  end
  
  # Gets a piston with a specific id.
  def get_piston(id : UInt32) : Piston
    p = pistons.find {|p| p.id == id}
    if p.nil?
      raise
    else
      p
    end
  end
  
  # Kills this engine
  def kill
    pistons.clear
    @to_merge.clear
  end

  # Gets an id number for a new `Piston`
  def make_id
    new_id = @id
    @id += 1
    new_id
  end

  # Has this engine ended yet?
  def ended?
    pistons.empty? && @to_merge.empty?
  end
end