require "kemal"
require "celestine"
require "../pixel_lang_crystal"


require "./programs"
require "./engines"

Programs.load 

Engines["hello_world"] = AutoEngine.new("hello_world", "./public/programs/basic/hello_world.png")
Engines["euler_2"] = AutoEngine.new("euler_2", "./public/programs/euler/2.png", "10")
Engines["ack"] = AutoEngine.new("ackermann", "./public/programs/test/ackermann.png", "10")

require "./macros/**"
require "./routes/**"



Kemal.run