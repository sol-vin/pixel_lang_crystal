class Piston
  getter engine : Engine

  property position_x : UInt32
  property position_y : UInt32

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
  #TODO: Replace random_int and random_char with non-pop versions
  SPECIAL_REG = REGISTERS[6..7]
  # Input options for register I
  INPUT_S_OPTIONS = [:int, :char, :no_pop_int, :no_pop_char]
  INPUT_D_OPTIONS = [:int, :char, :random_max, :null]
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
    #if we put a number on the stack
    if @i.empty?
      return case code
        when :int
          engine.grab_input_number
        when :char
          engine.grab_input_char
        when :no_pop_int
          x = 0
          total = ""
          while x < engine.input.size && ('0'..'9').includes?(engine.input[x])
            total += engine.input[x]
            x += 1
          end
          C20.new total.to_i
        when :no_pop_char
          C20.new engine.input[0].ord
        else
          raise "Option does not exist!"
      end
    end

    case code
      when :int
        @i.pop
      when :char
        @i.pop % 0x100
      when :no_pop_int
        @i.last
      when :no_pop_char
        @i.last % 0x100
      else
        raise "Option does not exist!"
    end
  end

  def set_i(v : C20, options)
    code = INPUT_D_OPTIONS[options]

    case code
      when :int
        @i << v
      when :char
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

  def do_math(s1, s1op, op, s2, s2op) : C20
    v1 = get(s1, s1op)
    v2 = get(s2, s2op)

    {% for o in Constants::OPERATIONS %}
      if op == {{o}} 
        return v1 {{o.id}} v2
      end  
    {% end %}
    raise  "BAD!"
  end

  def change_direction(d)
    if DIRECTIONS.includes? d
      @direction = d
    elsif d == :turn_right
      index = DIRECTIONS.index(@direction).as(Int32) + 1
      index = 0 if index >= DIRECTIONS.size
      change_direction(DIRECTIONS[index])
    elsif d == :turn_left  
      index = DIRECTIONS.index(@direction).as(Int32) - 1
      index = DIRECTIONS.size-1 if index < 0
      change_direction(DIRECTIONS[index])
    elsif d == :reverse
      change_direction :turn_left
      change_direction :turn_left  
    elsif d == :random
      change_direction DIRECTIONS.sample
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
  end

  # jumps to a relative position
  def call(x, y)
    @position_x += x
    @position_y += y
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

  def show_all
  end

  def show_info
    # Table with headings
    table = TerminalTable.new
    table.headings = ["Piston", "Value"]
    table.separate_rows = true
    table << ["id", "#{id}"]
    table << ["priority", "#{priority}"]    
    table << ["paused?", "#{paused?}"]
    table << ["pause_cycles", "#{paused_counter}"]    
    table << ["direction", "#{direction}"]
    table << ["position_x", "#{position_x}"]
    table << ["position_y", "#{position_y}"]        
    table.render
  end

  def show_registers
    table = TerminalTable.new
    table.headings = ["Register", "int", "hex"]
    table.separate_rows = true
    table << ["ma", "#{get_ma(0).value}", "#{get_ma(0).to_int_hex}"]
    table << ["mav", "#{get_mav(0).value}", "#{get_mav(0).to_int_hex}"]
    table << ["mb", "#{get_mb(0).value}", "#{get_mb(0).to_int_hex}"]
    table << ["mbv", "#{get_mbv(0).value}", "#{get_mbv(0).to_int_hex}"]
    table << ["s", "#{get_s(0).value}", "#{get_s(0).to_int_hex}"]
    table << ["sv", "#{get_sv(0).value}", "#{get_sv(0).to_int_hex}"]

    i_ints = ""
    i_hexes = ""

    @i.each do |item|
      i_ints += item.value.to_s + "\n"
      i_hexes += item.to_int_hex + "\n"
    end
    table << ["i", i_ints, i_hexes]

    table << ["o", "#{get_o(0).value}", "#{get_o(0).to_int_hex}"]
    table.render
  end

  def show_memory
    table = TerminalTable.new
    table.headings = ["Address", "int", "hex"]
    table.separate_rows = true
    
    @memory.keys.sort{|x, y| x.value <=> y.value}.each do |address|
      table << ["#{address.to_int_hex}", "#{@memory[address].to_s}", "#{@memory[address].to_int_hex}"]
    end
    
    table.render
  end

  def current_instruction
    engine.instructions[position_x, position_y]
  end
end