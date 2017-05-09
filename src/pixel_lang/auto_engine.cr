require "./engine"

class AutoEngine < Engine
  def write_output(item : C20, option : Symbol)
    case option
      when :int
        @output += item.value.to_s
      when :char
        @output += item.to_c
      when :int_hex
         @output += item.to_int_hex
      when :char_hex
         @output += item.to_char_hex
      else
        fail "option #{option} not valid!!!"
    end
    @last_output = item
  end

  # gets a number from input until it hits the end or a non-number char
  def grab_input_number
    # ''.to_i is equal to 0
    i = "0"
    while input.size != 0 && ('0'..'9').includes?(input[0])
      i += @input[0]
      @input = @input.delete(@input[0])
    end
    C20.new(i.to_i)
  end

    # gets the next input char
  def grab_input_char
    c = C20.new((@input.size == 0) ? 0 : @input[0].ord)
    @input = @input.delete(@input[0])
    c
  end
end