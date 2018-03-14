# Corrects colors using regex, (for example, gsub(/7?????/) {|color| color[:control_code] = 0xC})

require "../../../pixel_lang_crystal"

i = Instructions.new("./programs/basic/a_to_z.png")

i.map do |x,y,instruction|
  if instruction.control_code == 0x7
    
  instruction
end

i.save("./fixed_programs/a_to_z.png")