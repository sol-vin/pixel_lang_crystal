require "kemal"
require "../pixel_lang_crystal"

module Programs
  @@programs = {} of String => Array(String)

  def self.load
    dir = "./public/programs/"
    Dir.entries(dir).each do |entry|
      if File.directory?(dir + entry)     
        next if entry[0] == '.'
        @@programs[entry] = [] of String 
        Dir.entries(dir + entry).each do |file|
          next if file[0] == '.'
          @@programs[entry] << dir + entry + '/' + file
        end
      end
    end
  end

  def self.[](index)
    @@programs[index]
  end

  def self.keys
    @@programs.keys
  end
end

engines = {} of String => AutoEngine
engines["hello_world"] = AutoEngine.new("hello_world", "./public/programs/basic/hello_world.png")
engines["euler_2"] = AutoEngine.new("euler_2", "./public/programs/euler/2.png", "10")


# Displays main page



Kemal.run
