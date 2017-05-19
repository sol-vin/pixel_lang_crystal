require "./pixel_lang"

e = AutoEngine.new("Test", "./programs/fork_counter.png")

100.times do 
  puts e.show_instructions
  e.run_one_instruction
end
