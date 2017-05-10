require "./engine"

class LogEngine < AutoEngine
  def run(io : IO)
    colors = ["white", "red", "yellow", "green", "cyan", "blue", "magenta"]
    results = String::Builder.new
    until ended?
      color = {"foreground" => colors[cycles % colors.size], "background" => "black"}
      results << "\n".colorful(color)
      results << "----------------------------".colorful(color)
      results << "\n".colorful(color)
      results << "\n".colorful(color)
      results << "Cycle: #{cycles}".colorful(color)
      results << "\n".colorful(color)
      results << "Output: #{output}".colorful(color)
      results << "\n".colorful(color)
      results << pistons[0].current_instruction.show_info.colorful(color)
      results << "\n".colorful(color)
      run_one_instruction
      if pistons[0]?
        results << pistons[0].show_info.colorful(color)
        results << "\n".colorful(color)
        results << pistons[0].show_registers.colorful(color)
        results << "\n".colorful(color)
        results << pistons[0].show_memory.colorful(color)
        results << "\n".colorful(color)
      end  
    end
    io << results.to_s
  end

  def run
    File.open("log", "w+") do |f|
      run(f)
    end
  end
end