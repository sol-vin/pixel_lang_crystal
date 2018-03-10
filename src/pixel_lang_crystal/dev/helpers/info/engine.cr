require "../../../engine.cr"

class Engine
  def info
    table = [] of Array(String)
    table << ["Last Output", "#{last_output.value}"]
    table << ["Original Input", original_input] 
    table << ["Input", input]
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
end