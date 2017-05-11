class LogEngine < AutoEngine
  property io : IO = STDOUT
  COLORS = ["white", "red", "yellow", "green", "cyan", "blue", "magenta"]

  def run_one_instruction
    return if ended?
    color = {"foreground" => COLORS[cycles % COLORS.size], "background" => "black"}
    io << "\n".colorful(color)
    io << "<======================================>".colorful(color)
    io << "\n".colorful(color)
    io << "\n".colorful(color)
    io << "Cycle: #{cycles}".colorful(color)
    io << "\n".colorful(color)
    io << "Output: #{output}".colorful(color)
    io << "\n".colorful(color)
    piston_results = {} of UInt32 => String::Builder
    pistons.each do |piston|
      piston_results[piston.id] = String::Builder.new
      piston_results[piston.id] << piston.current_instruction.show_info
      piston_results[piston.id] << "\n"
      piston_results[piston.id] << piston.show_info
      piston_results[piston.id] << "\n"      
      piston_results[piston.id] << piston.show_registers
      piston_results[piston.id] << "\n"      
      piston_results[piston.id] << piston.show_memory
      piston_results[piston.id] << "\n"      
    end

    table = TerminalTable.new
    table.separate_rows = true

    headings = [] of String
    results = [] of String
    piston_results.each do |id, result|
      headings << id.to_s
      results << result.to_s
    end

    table.headings = headings
    table << results
    io << table.render.colorful(color)
    io << "\n"
    super
  end
end