class Piston
  getter engine : Engine

  property position_x : Int32
  property position_y : Int32

  getter direction : Symbol
  getter memory : Hash(C20, C20) = Hash(C20, C20).new(C20.new(0))

  getter? paused : Bool = false
  getter paused_counter : UInt32 = 0_u32

  getter? ended : Bool = false
  getter id : UInt32

  getter ma : C20 = C20.new(0)
  getter mb : C20 = C20.new(1)
  getter s : C20 = C20.new(0)
  getter i : Array(C20) = [] of C20
  
  getter priority : UInt32
  getter call_stack = [] of NamedTuple(x: Int32, y: Int32, direction: Symbol)
   # clockwise list of instructions
  DIRECTIONS = [:up, :right, :down, :left]
  
  # Total list of resisters
  REGISTERS = [:ma, :mav, :mb, :mbv, :s, :sv, :i, :o]
  
  # List of the regular registers, which all  operate the same. 
  # Regular registers allow access to a memory wheel.
  # Registers MA and MB refer to the current memory address for a local piston.
  # Registers MAV and MBV refer to the value pointed to by MA and MB.
  # Registers S and SV refer to the global memory.
  # All six registers here act the same way, and allow input and output
  MEMORY_ADDRESS_REG = [:ma, :mb, :s]
  MEMORY_VALUE_REG = [:ma, :mb]
  REGULAR_REG = REGISTERS[0..5]
  REGULAR_REG_S_OPTIONS = [:none, :random_max]
  REGULAR_REG_D_OPTIONS = [:none, :random_max]

  # List of the special registers, which have special meaning.
  # Register I is the input register. It allows access to the input buffer in the engine.
  # Register O is the output register. In allows access to the output buffer in the engine.
  # I and O work differently from each other and should be treated differently.
  # I grabs a char from the input buffer if gotten from (I is the/a source). For example using a AR IV + MAV -> OV instruction
  # IV grabs a value from memory, IC grabs only a char
  # Simply using the I register changes the input buffer.
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
  OUTPUT_D_OPTIONS =  [:int, :char, :int_hex, :char_hex]

  def initialize(@engine, @position_x, @position_y, @direction, @priority)
    @id = engine.make_id
    reset
  end

  def reset
    #TODO: Test reset
    @memory = Hash(C20, C20).new(C20.new(0))
    @call_stack = [] of NamedTuple(x: Int32, y: Int32, direction: Symbol)
    @ma = C20.new 0
    @mb = C20.new 1
    @s = C20.new 0
    @i = [] of C20
  end

  def get(register : Symbol, options) : C20
    {% for r in REGISTERS %}
      if register == {{r}}
        return get_{{r.id}}(options)
      end
    {% end %}
    raise "Register #{register} DOES NOT EXIST!"    
  end

  def set(register : Symbol, value, options)
    {% for r in REGISTERS %}
      if register == {{r}}
        set_{{r.id}}(value, options)
        return
      end
    {% end %}
    raise "Register #{register} DOES NOT EXIST!"    
  end

  {% for r in MEMORY_ADDRESS_REG %}
    def get_{{r.id}}(options) : C20
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

    def set_{{r.id}}(v : C20, options)
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
    def get_{{r.id}}v(options) : C20
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

    def set_{{r.id}}v(v : C20, options)
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

  def get_sv(options) : C20
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

  def set_sv(v : C20, options)
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

  def get_i(options) : C20
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

  def set_i(v : C20, options)
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

  def get_o(options) : C20
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
  def clone
    new_piston = Piston.new(engine, position_x, position_y, direction, @priority)
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

  def evaluate(s1, s1op, op, s2, s2op) : C20
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

  def change_direction(d)
    turn_right = -> do
      index = DIRECTIONS.index(@direction).as(Int32) + 1
      index = 0 if index >= DIRECTIONS.size
      change_direction(DIRECTIONS[index])
    end

    if DIRECTIONS.includes? d
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
    elsif d == :random
      rand(4).times {turn_right.call}
    else         
      raise "Direction does not exist!"
    end
  end

  # moves the instruction cursor amount units in a direction
  def move(amount)
    case direction
      when :up
        @position_y -= amount
      when :down
        @position_y += amount
      when :left
        @position_x -= amount
      when :right
        @position_x += amount      
      else
        raise "Option does not exist!"
    end

    wrap_position
  end

  private def wrap_position
    width = engine.instructions.width
    height = engine.instructions.height

    if position_x < 0
      @position_x = (width - (@position_x.abs % width))
    else
      @position_x %= width
    end

    if position_y < 0
      @position_y = (height - (@position_y.abs % height))
    else
      @position_y %= height
    end
  end

  # jumps to a relative position
  def call(x, y, push = true)
    if push
      @call_stack.push({x: @position_x, y: @position_y, direction: @direction})  
    end

    @position_x += x
    @position_y += y

    wrap_position
  end

  def return_call(pop = true)
    if pop
      call_frame = @call_stack.pop      
    else
      call_frame = @call_stack.last
    end
    @position_x = call_frame[:x]
    @position_y = call_frame[:y]
    change_direction call_frame[:direction]
    move 1
  end

  # pauses the piston for a certain amount of cycles
  def pause(cycles)
    @paused = true
    @paused_counter = cycles
  end

  # unpause the piston
  def unpause
    @paused = false
    @paused_counter = 0_u32
  end

  def pause_cycle
    if paused?
      @paused_counter -= 1
      if @paused_counter <= 0
        unpause
      end
    end
  end  

  # kill the piston
  def kill
    @ended = true
  end

  def info
    # Table with headings
    table = [] of Array(String)
    table << ["id", "#{id}"]
    table << ["priority", "#{priority}"]
    table << ["paused?", "#{paused?}"]
    table << ["pause_cycles", "#{paused_counter}"]
    table << ["direction", "#{direction}"]
    table << ["position_x", "#{position_x}"]
    table << ["position_y", "#{position_y}"]
    table
  end

  def registers
    table = [] of Array(String)
    table << ["Register", "int", "hex"]
    table << ["ma", "#{get_ma(0).value}", "#{get_ma(0).to_int_hex}"]
    table << ["mav", "#{get_mav(0).value}", "#{get_mav(0).to_int_hex}"]
    table << ["mb", "#{get_mb(0).value}", "#{get_mb(0).to_int_hex}"]
    table << ["mbv", "#{get_mbv(0).value}", "#{get_mbv(0).to_int_hex}"]
    table << ["s", "#{get_s(0).value}", "#{get_s(0).to_int_hex}"]
    table << ["sv", "#{get_sv(0).value}", "#{get_sv(0).to_int_hex}"]

    i_ints = ""
    i_hexes = ""

    @i.each do |item|
      i_ints += item.value.to_s + "/n"
      i_hexes += item.to_int_hex + "/n"
    end
    table << ["i", i_ints, i_hexes]

    table << ["o", "#{get_o(0).value}", "#{get_o(0).to_int_hex}"]
    table
  end

  def memory_dump
    table = [] of Array(String)
    table << ["Address", "int", "hex"]
    
    @memory.keys.sort{|x, y| x.value <=> y.value}.each do |address|
      table << ["#{address.to_int_hex}", "#{@memory[address].to_s}", "#{@memory[address].to_int_hex}"]
    end
    
    table
  end

  def current_instruction
    engine.instructions[position_x, position_y]
  end
end