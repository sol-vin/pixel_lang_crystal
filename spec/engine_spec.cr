require "spec"
require "../src/pixel_lang_crystal"
require "../src/pixel_lang_crystal/dev/helpers/**"

describe AutoEngine do
  it "should start" do
    e = AutoEngine.new("test", Instructions.new(10, 10))
  end

  it "should IMetaProperty" do
    i = Instructions.new(1, 4)
    i[0,3] = Start.make(:up, 0)
    i[0,2] = IMetaProperty.make(:height)
    i[0,1] = Move.make(:i, 0, :o, 0)
    i[0,0] = End.new(C24.new(0x0))
    e = AutoEngine.new("Test", i)
    e.pistons.size.should eq(1)
    100_000.times {e.step}
    e.output.should eq("4")

    i = Instructions.new(1, 10)
    i[0,3] = Start.make(:up, 0)
    i[0,2] = IMetaProperty.make(:height)
    i[0,1] = Move.make(:i, 0, :o, 0)
    i[0,0] = End.new(C24.new(0x0))
    e = AutoEngine.new("Test", i)
    e.pistons.size.should eq(1)
    100_000.times {e.step}
    e.output.should eq("10")

    i = Instructions.new(4, 1)
    i[3,0] = Start.make(:left, 0)
    i[2,0] = IMetaProperty.make(:width)
    i[1,0] = Move.make(:i, 0, :o, 0)
    i[0,0] = End.new(C24.new(0x0))
    e = AutoEngine.new("Test", i)
    e.pistons.size.should eq(1)
    100_000.times {e.step}
    e.output.should eq("4")
  end

  

  it "should run a_to_z" do
    e = AutoEngine.new("a_to_z", "./programs/basic/a_to_z.png")
    100_000.times {e.step}
    e.output.should eq(('A'..'Z').to_a.join)
  end

  it "should run a_to_z_art" do
    e = AutoEngine.new("a_to_z_art", "./programs/basic/a_to_z_art.png")
    100_000.times {e.step}
    e.output.should eq(('A'..'Z').to_a.join)
  end

  it "should run counter" do
    e = AutoEngine.new("counter", "./programs/basic/counter.png")
    100_000.times {e.step}
    e.output.should eq("12345678910")
  end

  it "should run fork_counter" do
    e = AutoEngine.new("fork_counter", "./programs/basic/fork_counter.png")
    100_000.times {e.step}
    e.output.should eq("123456789")
  end

  it "should run fibonacci" do
    a, b = 1, 0
    31.times do |x|
      b, a = a, b
      e = AutoEngine.new("fibonacci", "./programs/math/fibonacci.png", "#{x}")
      100_000.times {e.step}
      e.output.should eq("#{a}")
      a = a + b
    end  

    a, b = 1, 0
    31.times do |x|
      b, a = a, b
      e = AutoEngine.new("fibonacci_art", "./programs/math/fibonacci_art.png", "#{x}")
      100_000.times {e.step}
      e.output.should eq("#{a}")
      a = a+b
    end
  end

  it "should run fizzbuzz" do
    result = (1..100).to_a.map do |x|
       (x % 3 == 0) ? (x % 5 == 0 ? "FIZZBUZZ" : "FIZZ" ) : (x % 5 == 0 ? "BUZZ" : "#{x}" ) 
    end.join(" ") + " "

    e1 = AutoEngine.new("fizzbuzz", "./programs/basic/fizzbuzz.png", "100")
    e2 = AutoEngine.new("fizzbuzz_art", "./programs/basic/fizzbuzz_art.png", "100")
    100_000.times {e1.step}
    100_000.times {e2.step}

    e1.output.should eq(e2.output)
    e2.output.should eq(result)
  end

  it "should run num_bits" do
    e = AutoEngine.new("num_bits", "./programs/math/num_bits.png", "4")
    100_000.times {e.step}
    e.output.should eq("3")

    e = AutoEngine.new("num_bits", "./programs/math/num_bits.png", "8")
    100_000.times {e.step}
    e.output.should eq("4")

    e = AutoEngine.new("num_bits", "./programs/math/num_bits.png", "32")
    100_000.times {e.step}
    e.output.should eq("6")

    e = AutoEngine.new("num_bits", "./programs/math/num_bits.png", "128")
    100_000.times {e.step}
    e.output.should eq("8")

    e = AutoEngine.new("num_bits", "./programs/math/num_bits.png", "256")
    100_000.times {e.step}
    e.output.should eq("9")
  end

  it "should run sqrt" do
    e = AutoEngine.new("sqrt", "./programs/math/sqrt.png", "0")
    100_000.times {e.step}
    e.output.should eq("0")

    e = AutoEngine.new("sqrt", "./programs/math/sqrt.png", "1")
    100_000.times {e.step}
    e.output.should eq("1")

    e = AutoEngine.new("sqrt", "./programs/math/sqrt.png", "4")
    100_000.times {e.step}
    e.output.should eq("2")

    e = AutoEngine.new("sqrt", "./programs/math/sqrt.png", "9")
    100_000.times {e.step}
    e.output.should eq("3")

    e = AutoEngine.new("sqrt", "./programs/math/sqrt.png", "16")
    100_000.times {e.step}
    e.output.should eq("4")

    e = AutoEngine.new("sqrt", "./programs/math/sqrt.png", "64")
    100_000.times {e.step}
    e.output.should eq("8")

    e = AutoEngine.new("sqrt", "./programs/math/sqrt.png", "81")
    100_000.times {e.step}
    e.output.should eq("9")

    e = AutoEngine.new("sqrt", "./programs/math/sqrt.png", "#{999**2}")
    100_000.times {e.step}
    e.output.should eq("999")
  end

  it "should run euler_1" do
    e = AutoEngine.new("euler1", "./programs/euler/1.png", "10")
    100_000.times {e.step}
    e.output.should eq("23")

    e = AutoEngine.new("euler1", "./programs/euler/1.png", "1000")
    100_000.times {e.step}
    e.output.should eq("233168")
  end

  it "should run euler_2" do
    e = AutoEngine.new("euler2", "./programs/euler/2.png", "10")
    100_000.times {e.step}
    e.output.should eq("10")

    e = AutoEngine.new("euler2", "./programs/euler/2.png", "100")
    100_000.times {e.step}
    e.output.should eq("44")

    e = AutoEngine.new("euler2", "./programs/euler/2.png", "3000")
    100_000.times {e.step}
    e.output.should eq("3382")
  end

  it "should run calculator" do
    e = AutoEngine.new("calc", "./programs/math/calculator.png", "3000+382")
    100_000.times {e.step}
    e.output.should eq("3382")

    e = AutoEngine.new("calc", "./programs/math/calculator.png", "10-4")
    100_000.times {e.step}
    e.output.should eq("6")

    e = AutoEngine.new("calc", "./programs/math/calculator.png", "3*123")
    100_000.times {e.step}
    e.output.should eq("369")

    e = AutoEngine.new("calc", "./programs/math/calculator.png", "200/100")
    100_000.times {e.step}
    e.output.should eq("2")

    e = AutoEngine.new("calc", "./programs/math/calculator.png", "4%2")
    100_000.times {e.step}
    e.output.should eq("0")

    e = AutoEngine.new("calc", "./programs/math/calculator.png", "9%2")
    100_000.times {e.step}
    e.output.should eq("1")
    
    e = AutoEngine.new("calc", "./programs/math/calculator.png", "9%0")
    100_000.times {e.step}
    e.output.should eq("NaN")

    e = AutoEngine.new("calc", "./programs/math/calculator.png", "9/0")
    100_000.times {e.step}
    e.output.should eq("NaN")
  end

  it "should run prime" do
    e = AutoEngine.new("prime", "./programs/math/is_prime.png", "0")
    100_000.times {e.step}
    e.output.should eq("F")

    e = AutoEngine.new("prime", "./programs/math/is_prime.png", "1")
    100_000.times {e.step}
    e.output.should eq("T")

    e = AutoEngine.new("prime", "./programs/math/is_prime.png", "2")
    100_000.times {e.step}
    e.output.should eq("T")

    e = AutoEngine.new("prime", "./programs/math/is_prime.png", "3")
    100_000.times {e.step}
    e.output.should eq("T")

    e = AutoEngine.new("prime", "./programs/math/is_prime.png", "4")
    100_000.times {e.step}
    e.output.should eq("F")

    e = AutoEngine.new("prime", "./programs/math/is_prime.png", "5")
    100_000.times {e.step}
    e.output.should eq("T")

    e = AutoEngine.new("prime", "./programs/math/is_prime.png", "81")
    100_000.times {e.step}
    e.output.should eq("F")

    e = AutoEngine.new("prime", "./programs/math/is_prime.png", "229")
    100_000.times {e.step}
    e.output.should eq("T")

    e = AutoEngine.new("prime", "./programs/math/is_prime.png", "2323")
    100_000.times {e.step}
    e.output.should eq("F")
  end

  it "should run prime_sieve" do
    e = AutoEngine.new("prime", "./programs/math/prime_sieve.png", "100")
    100_000.times {e.step}
    e.output.should eq("2 3 5 7 11 13 17 19 23 29 31 37 41 43 47 53 59 61 67 71 73 79 83 89 97")
  end

  # it "should run sort" do
  #   e = AutoEngine.new("sort", "./programs/test/sort.png", "<1,2,3,4")
  #   10.times {e.step}
  #   e.output.should eq("1 2 3 4")

  #   e = AutoEngine.new("sort", "./programs/test/sort.png", "<4,3,2,1")
  #   10.times {e.step}
  #   e.output.should eq("4 3 2 1")
  # end
  
end