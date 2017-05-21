require "io/console"

require "./engine"

class LiveEngine < Engine
  def write_output(item : C20, option)
    case option
      when :int
        STDOUT.print item.value.to_s
        @output += item.value.to_s
      when :char
        STDOUT.print item.to_c
        @output += item.to_c
      when :int_hex
        STDOUT.print item.to_int_hex
        @output += item.to_int_hex
      when :char_hex
        STDOUT.print item.to_char_hex
        @output += item.to_char_hex
      else
        raise "Option error!"
    end
    @last_output = item
  end

  def grab_input_number
    puts "grab_input_number"
    if input.size == 0
      int = ""      
      until int != "" && int.to_s =~ /^[0-9]+$/
        int = self.gets("#{int != "" ? "!" : ""}#:").chomp
      end
      C20.new(int.to_i)
    else
      i = "0"
      while input.size != 0 && ('0'..'9').includes?(input[0])
        i += input[0]
        @input = input[1...input.chars.size]
      end
      C20.new(i.to_i)
    end
  end

  def grab_input_char
    if input.size == 0
      int = self.gets("$:").chomp
      @input += int
    end
    c = C20.new((input.size == 0) ? 0 : input[0].ord)
    @input = input[1...input.chars.size]
    c
  end

  def grab_input_char_no_pop
    i = C20.new 0
    if input.size == 0
      i = grab_input_char
    else
      i = C20.new input[0].ord
    end
    i
  end

  def grab_input_number_no_pop
    puts "grab_input_number_no_pop"
  
    x = 0
    total = ""
    while x < input.size && ('0'..'9').includes?(input[x])
      total += input[x]
      x += 1
    end
    if total == ""
      total = grab_input_number.value.to_s
    end  
    C20.new total.to_i
  end

  def gets(prompt)
    print prompt
    chars = ""

    until ["\r", "\n", "\r\n", "\u0003"].any?{|c| chars.includes?(c)}
      char = nil
      while char.nil?
        char = STDIN.read_byte
        if char == "\u007F"
          char = nil
          print "\r"
          (chars.size+prompt.size+1).times do
            print " "
          end
          chars = chars[0...input.chars.size-1]
          print "\r#{prompt}#{chars}"
        end
      end
      chars += char.chr
      STDOUT.write_byte char
    end
    chars
  end
end 