require "./pixel_lang"

e = AutoEngine.new("Test", "./programs/fizzbuzz.png", "5")

until e.ended? 
  puts e.show_instructions
  puts e.show_info
  x = e.pistons[0].position_x
  y = e.pistons[0].position_y
  puts e.pistons[0].show_info  
  puts e.pistons[0].show_registers
  puts e.instructions[x, y].show_info
  if e.instructions[x, y].is_a?(Conditional)
    puts "Evaluate: #{e.instructions[x, y].as(Conditional).evaluate(e.pistons[0])}"
  end
  sleep 5
  e.run_one_instruction
end

e.run
puts e.output