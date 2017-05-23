require "spec"
require "../src/pixel_lang_crystal"

describe AutoEngine do
  it "should start" do
    e = AutoEngine.new("test", Instructions.new(10, 10))
  end

  it "should run a simple program 1" do
    i = Instructions.new(3, 1)
    s = Start.new(C24.new(0x100000))
    s.value[:direction] = 1_u32    
    i[0,0] = s
    i[1,0] = OutputChar.new(C24.new(0xB00042))    
    i[2,0] = End.new(C24.new(0x0))
    e = AutoEngine.new("Test", i)
    e.pistons.size.should eq(1)
    e.run
    e.output.should eq("B")
  end

  it "should run a simple program 2" do
    i = Instructions.new(1, 3)
    i[0,2] = Start.make(:up, 0)
    i[0,1] = OutputChar.new(C24.new(0xB00044))    
    i[0,0] = End.new(C24.new(0x0))
    e = AutoEngine.new("Test", i)
    e.pistons.size.should eq(1)
    e.run
    e.output.should eq("D")
  end

  it "should run a simple Arithmetic" do
    i = Instructions.new(1, 5)
    i[0, 0] = Start.make(:down, 0)
    i[0, 1] = Insert.new(C24.new(0x80000A))
    i[0, 2] = Insert.new(C24.new(0x800014))
    i[0, 3] = Arithmetic.make(:i, 0, :+, :i, 0, :o, 0)
    i[0, 4] = End.new(C24.new(0x0))
    e = AutoEngine.new("Test", i)
    e.run
    e.output.should eq("30")

    i[0, 3] = Arithmetic.make(:i, 0, :/, :i, 0, :o, 0)
    e = AutoEngine.new("Test", i)
    e.run
    e.output.should eq("2")

    i[0, 3] = Arithmetic.make(:i, 0, :*, :i, 0, :o, 0)
    e = AutoEngine.new("Test", i)
    e.run
    e.output.should eq("200")

    i[0, 3] = Arithmetic.make(:i, 0, :-, :i, 0, :o, 0)
    e = AutoEngine.new("Test", i)
    e.run
    e.output.should eq("10")
  end

  it "should run a_to_z" do
    e = AutoEngine.new("a_to_z", "./programs/a_to_z.png")
    e.run
    e.output.should eq(('A'..'Z').to_a.join)
  end

  it "should run a_to_z_art" do
    e = AutoEngine.new("a_to_z_art", "./programs/a_to_z_art.png")
    e.run
    e.output.should eq(('A'..'Z').to_a.join)
  end

  it "should run counter" do
    e = AutoEngine.new("counter", "./programs/counter.png")
    e.run
    e.output.should eq("12345678910")
  end

  it "should run fork_counter" do
    e = AutoEngine.new("fork_counter", "./programs/fork_counter.png")
    e.run
    e.output.should eq("123456789")
  end

  it "should run fibonacci" do
    a, b = 1, 0
    31.times do |x|
      b, a = a, b
      e = AutoEngine.new("fibonacci", "./programs/fibonacci.png", "#{x}")
      e.run
      e.output.should eq("#{a}")
      a = a+b
    end  

    a, b = 1, 0
    31.times do |x|
      b, a = a, b
      e = AutoEngine.new("fibonacci_art", "./programs/fibonacci_art.png", "#{x}")
      e.run
      e.output.should eq("#{a}")
      a = a+b
    end
  end

  it "should run fizzbuzz" do
    result = (1..100).to_a.map do |x|
       (x % 3 == 0) ? (x % 5 == 0 ? "FIZZBUZZ" : "FIZZ" ) : (x % 5 == 0 ? "BUZZ" : "#{x}" ) 
    end.join(" ") + " "

    e1 = AutoEngine.new("fizzbuzz", "./programs/fizzbuzz.png", "100")
    e2 = AutoEngine.new("fizzbuzz_art", "./programs/fizzbuzz_art.png", "100")
    e1.run
    e2.run

    e1.output.should eq(e2.output)
    e2.output.should eq(result)
  end
end