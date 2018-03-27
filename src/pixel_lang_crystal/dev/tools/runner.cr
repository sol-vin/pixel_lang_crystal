require "../../../pixel_lang_crystal"

a = AutoEngine.new "runner", ARGV[0], ARGV[1]

if ARGV.size == 3
  ARGV[2].to_i.times do |i|
    a.step
  end
else
  a.run
end

puts a.output

puts "EXECUTION TIME: #{a.cycles}"
