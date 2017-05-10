require "./pixel_lang"

e = AutoEngine.new("Test", "./programs/a_to_z.png")
e.run
puts e.output
#colors = ["white", "red", "yellow", "green", "cyan", "blue", "magenta"]

#100.times do
#  color = {"foreground" => colors[e.cycles % colors.size], "background" => "black"}
#  puts
#  puts "----------------------------".colorful(color)
#  puts
#  puts "Cycle: #{e.cycles}".colorful(color)
#  puts "Output: #{e.output}".colorful(color)
#  puts e.pistons[0].current_instruction.show_info.colorful(color)
#  e.run_one_instruction  
#  puts e.pistons[0].show_info.colorful(color)
#  puts e.pistons[0].show_registers.colorful(color)
#  puts e.pistons[0].show_memory.colorful(color)
#end
