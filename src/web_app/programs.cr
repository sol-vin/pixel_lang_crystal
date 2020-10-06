module Programs
  @@programs = {} of String => Array(String)

  def self.load
    dir = "./public/programs/"
    @@programs.clear
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
