require "./pixel_lang"

e = LogEngine.new("Test", "./programs/a_to_z.png")
e.run(STDOUT)
puts e.output
