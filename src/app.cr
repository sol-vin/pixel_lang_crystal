require "./pixel_lang"

i = Instructions.new(3, 1)
i[0,0] = Start.new(C24.new(0x100000))
i[0,0].value[:direction] = 1_u32
i[1,0] = OutputChar.new(C24.new(0xB00042))
i[2,0] = End.new(C24.new(0x0))
e = AutoEngine.new("Test", i)
e.run
puts e.output == "B"

