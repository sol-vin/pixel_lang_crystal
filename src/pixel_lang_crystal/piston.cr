# A single reader attached to an `Engine`
class Piston
  # The parent engine this `Piston` is attached to.
  getter engine : Engine
  
  # X position
  property x : Int32

  # Y position 
  property y : Int32
  
  # Facing direction
  getter direction : Symbol

  # Memory hash, values default to C20.new(0)
  getter memory : Hash(C20, C20) = Hash(C20, C20).new(C20.new(0))

  # If this is paused
  getter? paused : Bool = false
  # How much longer it's paused.'
  getter paused_counter : UInt32 = 0_u32
  
  # Have we read an `End` instruction?
  getter? ended : Bool = false

  # Id given by the `Engine`
  getter id : UInt32
  
  # Memory Address A register
  getter ma : C20 = C20.new(0)
  # Memory Address B register
  getter mb : C20 = C20.new(1)
  # Static Address register
  getter s : C20 = C20.new(0)
  # Input register
  getter i : Array(C20) = [] of C20
  
  # Priority compared to other pistons.
  getter priority : UInt32
  # List of call frames to return to when hitting a `Call` return.
  getter call_stack = [] of Piston
  
  # Total list of resisters
  REGISTERS = [:ma, :mav, :mb, :mbv, :s, :sv, :i, :o]
  
  # List of the regular registers, which all  operate the same. 
  # Regular registers allow access to a memory wheel.
  # Registers MA and MB refer to the current memory address for a local piston.
  # Registers MAV and MBV refer to the value pointed to by MA and MB.
  # Registers S and SV refer to the global memory.
  # All six registers here act the same way, and allow input and output
  REGULAR_REG = REGISTERS[0..5]
  
  MEMORY_ADDRESS_REG = [:ma, :mb, :s]
  MEMORY_VALUE_REG = [:ma, :mb]
  REGULAR_REG_S_OPTIONS = [:none, :random_max]
  REGULAR_REG_D_OPTIONS = [:none, :random_max]

  # List of the special registers, which have special meaning.
  # Register I is the input register. It allows access to the input buffer in the engine.
  # Register O is the output register. In allows access to the output buffer in the engine.
  # I and O work differently from each other and should be treated differently.
  # I grabs a char from the input buffer if gotten from (I is the/a source). For example using a AR I + MAV -> O instruction
  # Simply reading from the I register can change the input buffer.
  # The I register can also be written to, to be used as a stack. The stack is piston local and does not append the input.
  # The O register kind of works the opposite. 
  # When O is written to (is the destination) it writes to the output buffer. You can control whether it writes as a char, int, hex int, hex char.
  # If O is the/a source it will give back the last 20-bits that was given to output, this is globally shared between all pistons
  #TODO:  WRITE ABOUT SPECIAL RANDOM REGISTER OPTIONS
  SPECIAL_REG = REGISTERS[6..7]
  # Input options for register I
  INPUT_S_OPTIONS = [:pop_int, :pop_char, :peek_int, :peek_char]
  INPUT_D_OPTIONS = [:push_int, :push_char, :random_max, :null]
  OUTPUT_S_OPTIONS = [:int, :char, :random_max, :random]
  # Output options for register O
  OUTPUT_D_OPTIONS = [:int, :char, :int_hex, :char_hex]

  def initialize(@engine, @x, @y, @direction, @priority, id = nil)
    if id.nil?
      @id = engine.make_id
    else
      @id = id
    end
    reset
  end
  
  # Resets the internal state
  def reset
    #TODO: Test reset
    @memory = Hash(C20, C20).new(C20.new(0))
    @call_stack = [] of Piston
    @ma = C20.new 0
    @mb = C20.new 1
    @s = C20.new 0
    @i = [] of C20
  end
  
  # Gets a register by symbol.
  def get(register : Symbol, options : Int) : C20
    {% for r in REGISTERS %}
      if register == {{r}}
        return get_{{r.id}}(options)
      end
    {% end %}
    raise "Register #{register} DOES NOT EXIST!"
  end
  
  # Sets a register by symbol.
  def set(register : Symbol, value : C20, options : Int)
    {% for r in REGISTERS %}
      if register == {{r}}
        set_{{r.id}}(value, options)
        return
      end
    {% end %}
    raise "Register #{register} DOES NOT EXIST!"
  end
  
  {% for r in MEMORY_ADDRESS_REG %}
    # Macro created.
    def get_{{r.id}}(options : Int) : C20
      option = REGULAR_REG_S_OPTIONS[options]
      case option
        when :none
          @{{r.id}}
        when :random_max
          C20.new rand(@{{r.id}}.value)
        else
          raise "Option does not exist!"
      end
    end
    # Macro created.
    def set_{{r.id}}(v : C20, options : Int)
      option = REGULAR_REG_D_OPTIONS[options]
      case option
        when :none
          @{{r.id}} = v
        when :random_max
          @{{r.id}} = C20.new(rand(v.value))
        else
          raise "Option does not exist!"
      end
    end
  {% end %}

  {% for r in MEMORY_VALUE_REG %}
    # Macro created.  
    def get_{{r.id}}v(options : Int) : C20
      option = REGULAR_REG_S_OPTIONS[options]
      case option
        when :none
          memory[@{{r.id}}]
        when :random_max
          C20.new rand(memory[@{{r.id}}].value)
        else
          raise "Option does not exist!"
      end
    end
    
    # Macro created.    
    def set_{{r.id}}v(v : C20, options : Int)
      option = REGULAR_REG_D_OPTIONS[options]
      case option
        when :none
          @memory[@{{r.id}}] = v
        when :random_max
          @memory[@{{r.id}}] = C20.new rand(v.value)
        else
          raise "Option does not exist!"
      end
    end
  {% end %}
  
  def get_sv(options : Int) : C20
    option = REGULAR_REG_S_OPTIONS[options]
    case option
      when :none
        engine.memory[@s]
      when :random_max
        C20.new rand(engine.memory[@s].value)
      else
        raise "Option does not exist!"
    end
  end

  def set_sv(v : C20, options : Int)
    option = REGULAR_REG_D_OPTIONS[options]
    case option
      when :none
        engine.memory[@s] = v
      when :random_max
        engine.memory[@s] = C20.new rand(v.value)
      else
        raise "Option does not exist!"
    end
  end

  def get_i(options : Int) : C20
    code = INPUT_S_OPTIONS[options]
    # if there is nothing on this pistons stack, lets try the engine's input'
    if @i.empty?
      return case code
        when :pop_int
          engine.pop_int
        when :pop_char
          engine.pop_char
        when :peek_int
          engine.peek_int
        when :peek_char
          engine.peek_char
        else
          raise "Option does not exist!"
      end
    end

    case code
      when :pop_int
        @i.pop
      when :pop_char
        @i.pop % 0x100
      when :peek_int
        @i.last
      when :peek_char
        @i.last % 0x100
      else
        raise "Option does not exist!"
    end
  end

  def set_i(v : C20, options : Int)
    code = INPUT_D_OPTIONS[options]

    case code
      when :push_int
        @i << v
      when :push_char
        @i << C20.new(v.value % 0x100)
      when :null
        # Throw the value away
      when :random_max
        @i << C20.new rand(v.value)
      else
        raise "Option does not exist!"
    end
  end

  def get_o(options : Int) : C20
    code = OUTPUT_S_OPTIONS[options]
    case code
      when :int
        engine.last_output
      when :char
        C20.new engine.last_output.value % 0x100
      when :random_max
        C20.new rand(engine.last_output.value)
      when :random
        C20.new rand(C20::MAX)
      else
        raise "Option does not exist!"
    end
  end

  def set_o(v : C20, options)
    code = OUTPUT_D_OPTIONS[options]
    engine.write_output(v, code)
  end

  #TODO: TEST CLONE!
  # Clones this piston except for the ID, this can be put into Engine#pistons directly.
  def clone_new
    new_piston = Piston.new(engine, x, y, direction, @priority, id = nil)
    @memory.each do |address, value|
      new_piston.memory[address] = value
    end

    new_piston.set_ma(@ma, 0)
    new_piston.set_mb(@mb, 0)
    new_piston.set_s(@s, 0)
    @i.reverse.each do |c|
      new_piston.set_i(c, 0)
    end

    new_piston
  end

  # Clones this piston with the same ID. DO NOT INJECT THIS INTO Engine#pistons without first deleting the old one.
  def clone
    new_piston = Piston.new(engine, x, y, direction, @priority, @id)
    @memory.each do |address, value|
      new_piston.memory[address] = value
    end

    new_piston.set_ma(@ma, 0)
    new_piston.set_mb(@mb, 0)
    new_piston.set_s(@s, 0)
    @i.reverse.each do |c|
      new_piston.set_i(c, 0)
    end

    new_piston
  end
  
  # Evaluates an expression using symbols.
  def evaluate(s1 : Symbol, s1op : Int, op : Symbol, s2 : Symbol, s2op : Int) : C20
    v1 = get(s1, s1op)
    v2 = get(s2, s2op)

    #stop div by zero
    if op == :/ && (v2.value == 0)
      #puts "DIV BY ZERO!"
      return C20.new(0)
    elsif op == :% && (v2.value == 0)
      #puts "MOD BY ZERO!"
      return v1
    end

    {% for o in Constants::ARITHMETIC_OPERATIONS %}
      if op == {{o}} 
        return v1 {{o.id}} v2
      end  
    {% end %}

    {% for o in Constants::BOOLEAN_OPERATIONS %}
      if op == {{o}} 
        return C20.new((v1 {{o.id}} v2) ? Constants::TRUE : Constants::FALSE)
      end  
    {% end %}
    raise  "BAD!"
  end
  
  # Changes the direction to the specified direction
  def change_direction(d : Symbol)
    turn_right = -> do
      index = Constants::BASIC_DIRECTIONS.index(@direction).as(Int32) + 1
      index = 0 if index >= Constants::BASIC_DIRECTIONS.size
      change_direction(Constants::BASIC_DIRECTIONS[index])
    end

    if Constants::BASIC_DIRECTIONS.includes? d
      @direction = d
    elsif d == :turn_right
      turn_right.call
    elsif d == :turn_left
      # Two wrongs don't make a right but three rights make a left
      turn_right.call
      turn_right.call
      turn_right.call
    elsif d == :reverse
      turn_right.call
      turn_right.call
    elsif d == :straight
      #do nothing
    else
      raise "Direction does not exist!"
    end
  end

  # moves the instruction cursor amount units in a direction
  def move(amount : Int)
    case direction
      when :up
        @y -= amount
      when :down
        @y += amount
      when :left
        @x -= amount
      when :right
        @x += amount
      else
        raise "Option does not exist!"
    end

    wrap_position
  end
  
  # Wrap the board position around if the piston goes off screen.
  private def wrap_position
    width = engine.instructions.width
    height = engine.instructions.height

    if x < 0
      @x = (width - (@x.abs % width))
    else
      @x %= width
    end

    if y < 0
      @y = (height - (@y.abs % height))
    else
      @y %= height
    end
  end

  # jumps to a relative position
  def call(x : Int, y : Int, push = true)
    # If we push to call stack, push an exact copy of this piston onto the call stack.
    if push
      @call_stack.push(self.clone)  
    end

    @x += x
    @y += y

    wrap_position
  end
  
  # Returns to the last call frame
  def return_call(action : Symbol, 
                  copy_ma : Bool,
                  copy_mb : Bool,
                  copy_s : Bool,
                  copy_i : Symbol,
                  copy_memory : Symbol,
                  copy_x : Bool,
                  copy_y : Bool,
                  copy_direction : Bool
                  )
    # If the call frame should be popped or not
    unless @call_stack.empty?
      if action == :pop
        frame = @call_stack.pop
      elsif action == :peek
        frame = @call_stack.last
      elsif action == :pop_push
        frame = @call_stack.pop
        @call_stack.push(self.clone)
      elsif action == :peek_push
        frame = @call_stack.last
        @call_stack.push(self.clone)
      else
        raise "Action invalid!"
      end
      # Set the registers if they nee d to be copied
      set_ma(frame.ma, 0) if copy_ma
      set_mb(frame.mb, 0) if copy_mb
      set_s(frame.s, 0) if copy_s

      # copy I by reversing it and pushing the items back on.
      if copy_i == :restore
        @i.clear
        frame.i.reverse.each do |value|
          set_i(value, 0)
        end
      elsif copy_i == :keep
        # do nothing
      elsif copy_i == :clear
        @i.clear
      end
      
      # copy the memory if needed
      if copy_memory == :restore
        @memory.clear
        frame.memory.each do |address, value|
          @memory[address] = value
        end
      elsif copy_memory == :keep
        # do nothing
      elsif copy_memory == :clear
        @memory.clear
      end

      @x = frame.x if copy_x
      @y = frame.y if copy_y
      change_direction(frame.direction) if copy_direction
    end
  end
  
  # Current instruction the piston is on.
  def current_instruction
    engine.instructions[x, y]
  end
  
  # Runs one instruction
  def step
    if paused?
      # Run the pause tick
      pause_cycle
      # move one if we just unpaused during the tick.
      move(1) unless paused?
    else
      instruction = current_instruction
      instruction.run(self)

      # move unless we called recently because we want to land on the right instruction.
      # We do this because the instruction it lands on will be skipped immeadiately.
      # also dont move if we just paused
      move((instruction.class == Call || instruction.class == Pause) ? 0 : 1)
    end
  end

  # Pauses the piston for a certain amount of cycles
  def pause(cycles)
    @paused = true
    @paused_counter = cycles
  end

  # Unpause the piston
  def unpause
    @paused = false
    @paused_counter = 0_u32
  end
  
  # One update tick when paused.
  private def pause_cycle
    if paused?
      @paused_counter -= 1
      if @paused_counter <= 0
        unpause
      end
    end
  end  

  # Kills the piston
  def kill
    @ended = true
  end
end