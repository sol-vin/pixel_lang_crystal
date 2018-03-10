require "../../../piston.cr"

class Piston
  def info
    # Table with headings
    table = [] of Array(String)
    table << ["id", "#{id}"]
    table << ["priority", "#{priority}"]
    table << ["paused?", "#{paused?}"]
    table << ["pause_cycles", "#{paused_counter}"]
    table << ["direction", "#{direction}"]
    table << ["x", "#{x}"]
    table << ["y", "#{y}"]
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
end