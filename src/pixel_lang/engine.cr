abstract class Engine
  OUTPUT_OPTIONS = [:int, :char, :int_hex, :char_hex]

  getter pistons : Array(Piston)
  getter instructions : Instructions
  getter output : String
  getter cycles : UInt32
  #TODO: Log?

  getter name : String
  getter runs : UInt32
  getter memory : Hash(C20, C20)
  getter input : String
  getter last_output : C20

  abstract def write_output(item : C20, option : Symbol)
  abstract def grab_input_char : C20
  abstract def grab_input_number : C20

  def initialize(image_file, @input = "")
    @original_input = input.clone
    @name = image_file.split('/').last.split('.').first
    @runs = 0
    @original_image_file = image_file
    reset # start the machine
  end

  def reset
    @id = 0
    @cycles = 0_u32
    @output = ""
    @to_merge = [] of Tuple(Int32, Piston)
    @pistons = [] of Piston
    @memory = Hash(C20, C20).new(C20.new)
    @input = @original_input.clone
    @last_output = C20.new

    @instructions = Instructions.new image_file    
    @instructions.start_points.each do |sp|
      @pistons << Piston.new(self, sp[:x], sp[:y], sp[:direction], sp[:priority])
    end
    @runs += 1
  end

  def run
    until ended?
      run_one_instruction 
    end  
  end

  def run_one_instruction
    # don't run if the machine has already ended.
    return if ended?
    # run an instruction on all pistons.
    pistons.each(&.run_one_instruction)
    # merge pistons
    # pistons end up in @to_merge from fork_piston and are added
    # after instructions are ran
    @to_merge.each do |merge|
      piston_index = pistons.find_index { |piston| piston.id == merge.piston.id }
      pistons.insert(piston_index, merge.new_piston)
      end
    end
    @to_merge.clear

    # prune old pistons, delete the ones that no longer are active
    @pistons.select! { |t| !t.ended? }
    @cycles += 1
  end

    # forks a piston in a specific direction
  def merge(piston_id, new_piston)
    @to_merge << {piston_id, new_piston}
  end

  def priority_changed(piston)
    #remove the piston
    @pistons.delete(piston)
    #find the first piston whose priority is lower
    p = @pistons.find {|p| p.priority <= piston.priority}
    @to_merge << {p.id, piston}
  end

  def kill
    pistons.clear
    @to_merge.clear
  end

  # gets an id number for the Piston
  def make_id
    new_id = @id
    @id += 1
    new_id
  end

  def ended?
    pistons.empty? && @to_merge.empty?
  end
end