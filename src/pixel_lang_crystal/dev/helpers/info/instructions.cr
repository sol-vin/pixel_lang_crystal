class Start
  def info
    # Table with headings
    table = super
    table << ["priority", "#{value[:priority]}"]
    table << ["direction", "#{Constants::BASIC_DIRECTIONS[value[:direction]]}"]
    table
  end
end

class Direction
  def info
    # Table with headings
    table = super
    table << ["direction", "#{Constants::DIRECTIONS[value[:value] % Constants::DIRECTIONS.size]}"]
    table
  end
end

class Fork
  def info
    # Table with headings
    table = super
    table << ["direction_1", Constants::DIRECTIONS[value[:direction_1]].to_s]
    table << ["direction_2", Constants::DIRECTIONS[value[:direction_2]].to_s]
    table << ["direction_3_bool", value[:direction_3_bool].to_s]
    table << ["direction_3", Constants::DIRECTIONS[value[:direction_3]].to_s]
    table << ["direction_4_bool", value[:direction_4_bool].to_s]
    table << ["direction_4", Constants::DIRECTIONS[value[:direction_4]].to_s]
    table
  end
end

class Call
  def info
    # Table with headings
    table = super
    table << ["action", "#{Call::ACTIONS[value[:action]]}"]
    table << ["x", "#{((value[:x_sign] == 0) ? value[:x] : -(value[:x].to_i32))}"]
    table << ["y", "#{((value[:y_sign] == 0) ? value[:y] : -(value[:y].to_i32))}"]
    table
  end
end

class Return
  def info
    # Table with headings
    table = super
    table << ["action",  Return::ACTIONS[value[:action]].to_s]
    table << ["ma",  value[:ma] == Constants::TRUE]
    table << ["mb",  value[:mb] == Constants::TRUE]
    table << ["s",  value[:s] == Constants::TRUE]
    table << ["i",  Return::I_ACTIONS[value[:i]].to_s]
    table << ["memory",  Return::MEMORY_ACTIONS[value[:memory]].to_s]
    table << ["x",  value[:x] == Constants::TRUE]
    table << ["y",  value[:y] == Constants::TRUE]
    table << ["direction",  value[:direction] == Constants::TRUE]
    table
  end
end

class Move
  def info
    # Table with headings
    table = super
    table << ["s", Piston::REGISTERS[value[:s]].to_s]
    table << ["sop", value[:sop].to_s]
    table << ["d", Piston::REGISTERS[value[:d]].to_s]
    table << ["dop", value[:dop].to_s]
    table << ["swap", value[:swap].to_s]
    table << ["reverse", value[:reverse].to_s]
    
    table
  end
end

class Arithmetic
  def info
    # Table with headings
    table = super
    table << ["s1", Piston::REGISTERS[value[:s1]].to_s]
    table << ["s1op", value[:s1op].to_s]
    table << ["op", Constants::OPERATIONS[value[:op]].to_s]
    table << ["s2", Piston::REGISTERS[value[:s2]].to_s]
    table << ["s2op", value[:s2op].to_s]
    table << ["d", Piston::REGISTERS[value[:d]].to_s]
    table << ["dop", value[:dop].to_s]
    table << ["invert", (value[:invert] != 0).to_s]
    table
  end
end

class OutputChar
  def info
    # Table with headings
    table = super
    table << ["char", (value[:value] % 0x100).chr.to_s]
    table
  end
end

class IMetaGet
  def info
    # Table with headings
    table = super
    table << ["x", Piston::REGISTERS[value[:x]].to_s]
    table << ["xo", value[:xop].to_s]
    table << ["y", Piston::REGISTERS[value[:y]].to_s]
    table << ["yo", value[:yop].to_s]
    
    table
  end
end

class Conditional
  def info
    # Table with headings
    table = super
    table << ["true_action",  Constants::DIRECTIONS[value[:true_action]].to_s]
    table << ["false_action",  Constants::DIRECTIONS[value[:false_action]].to_s]
    table << ["s1", Piston::REGISTERS[value[:s1]].to_s]
    table << ["s1op", value[:s1op].to_s]
    table << ["op", Constants::OPERATIONS[value[:op]].to_s]
    table << ["s2", Piston::REGISTERS[value[:s2]].to_s]
    table << ["s2op", value[:s2op].to_s] 
    
    table
  end
end






