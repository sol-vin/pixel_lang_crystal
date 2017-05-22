abstract class Engine
  OUTPUT_OPTIONS = [:int, :char, :int_hex, :char_hex]

  getter pistons : Array(Piston) = [] of Piston
  getter instructions : Instructions = Instructions.new(1,1)
  getter output : String = ""
  getter cycles : UInt32 = 0_u32

  getter id : UInt32 = 0_u32
  getter name : String
  getter runs : UInt32 = 0_u32
  getter memory : Hash(C20, C20) = Hash(C20,C20).new(C20.new(0))
  getter input : String = ""
  getter last_output : C20 = C20.new(0)

  abstract def write_output(item : C20, option : Symbol)
  abstract def pop_char : C20
  abstract def peek_char : C20  
  abstract def pop_int : C20
  abstract def peek_int : C20  

  @to_merge = [] of Tuple(Int32, Piston)

  def initialize(@name : String, image_file : String, @original_input = "")
    @name = image_file.split('/').last.split('.').first
    @original_instructions = Instructions.new(image_file)
    reset # start the machine
  end

  def initialize(@name : String, @original_instructions : Instructions, @original_input = "")
    reset # start the machine
  end

  def reset
    @id = 0_u32
    @cycles = 0_u32
    @output = ""
    @to_merge = [] of Tuple(Int32, Piston)
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

  def run
    until ended?
      run_one_instruction 
    end  
  end

  def run_one_instruction
    # don't run if the machine has already ended.
    return if ended?
    # run an instruction on all pistons.
    @pistons.each do |p|
      if p.paused?
        p.pause_cycle
      else
        instruction = instructions[p.position_x, p.position_y]

        unless instruction
          raise "AT POSITION #{p.position_x}   #{p.position_y}"
        end
        
        instruction.run(p)

        #move unless we called recently.
        p.move 1 unless instruction.class == Call
        #wrap the piston around if it moves off screen.
        if p.position_x < 0
          p.position_x = (instructions.width - (p.position_x.abs % instructions.width)).to_u32
        else
          p.position_x %= instructions.width
        end

        if p.position_y < 0
          p.position_y = (instructions.height - (p.position_y.abs % instructions.height)).to_u32
        else
          p.position_y %= instructions.height
        end
      end
    end
    # merge pistons
    # pistons end up in @to_merge from fork_piston and are added
    # after instructions are ran
    @to_merge.each do |merge|
      piston_index = (pistons.index { |piston| piston.id == merge[0]}).as(Int32)
      pistons.insert(piston_index, merge[1])
    end
    @to_merge.clear

    # prune old pistons, delete the ones that no longer are active
    @pistons.select! { |t| !t.ended? }
    @cycles += 1
  end

    # forks a piston in a specific direction
  def merge(piston, new_piston)
    @to_merge << {piston.id.to_i32, new_piston}
  end

  def priority_changed(piston)
    #remove the piston
    @pistons.delete(piston)
    #find the first piston whose priority is lower
    p = @pistons.find {|p| p.priority <= piston.priority}
    @to_merge << {p.id, piston}
  end

  def get_piston(id : UInt32) : Piston
    p = pistons.find {|p| p.id == id}
    if p.nil?
      raise
    else
      p
    end
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

  def info
    table = [] of Array(String)
    table << ["Output", "#{output}"]
    table << ["Last Output", "#{last_output}"]
    
    table << ["Input", "#{input}"]
    table << ["Cycles", "#{cycles}"]
    table << ["ID", "#{@id}"]
    
    table
  end

  def show_memory
    table = [] of Array(String)
    
    @memory.keys.sort{|x, y| x.value <=> y.value}.each do |address|
      table << ["#{address.to_int_hex}", "#{@memory[address].to_s}", "#{@memory[address].to_int_hex}"]
    end
    
    table
  end

  def show_instructions
    i = [] of Char
    (0...instructions.height).each do |y|
      (0...instructions.width).each do |x|
        i << instructions[x, y].char
      end
    end

    output = String::Builder.new
    i.each_with_index do |c, i|
      x = i % instructions.width
      y = i / instructions.width
      p = pistons.select do |p|
        p.position_x == x && p.position_y == y
      end

      color = {"foreground" => "white", "background" => "black"}        
      output << "\n\n\n".colorful(color) if x == 0


      unless p.empty?
        if p.size == 1
          color = {"foreground" => Constants::COLORS[p[0].id  % Constants::COLORS.size], "background" => "black"}
          if c == ' '
            p_c = case p[0].direction
                    when :up
                      '\u2191'
                    when :down
                      '\u2193'
                    when :left
                      '\u2190'
                    when :right
                      '\u2192'
                    else 
                      '?'  
                  end
            output << (p_c + "     ").colorful(color)
          else
            output << (c + "     ").colorful(color)
          end
        else
          color = {"background" => Constants::COLORS[p.size % Constants::COLORS.size], "foreground" => "black"}          
          output << (c + " <#{p.size.to_s.rjust(2, ' ')} ").colorful(color)
        end
      else
        color = {"foreground" => "white", "background" => "black"}        
        output << (c + "     ").colorful(color)
      end
    end
    output.to_s
  end
end