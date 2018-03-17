require "spec"
require "../../src/pixel_lang_crystal"
require "../../src/pixel_lang_crystal/dev/helpers/**"

describe Arithmetic do
  it "should run a simple Arithmetic" do
    i = Instructions.new(5, 1)
    i[0,0] = Start.make(:right)
    i[1,0] = Insert.make(10)
    i[2,0] = Insert.make(20)
    i[3,0] = Arithmetic.make(:i, 0, :+, :i, 0, :o, 0)
    i[4,0] = End.make()

    e = AutoEngine.new("Test", i)
    5.times {e.step}
    e.output.should eq("30")

    i[3,0] = Arithmetic.make(:i, 0, :/, :i, 0, :o, 0)
    e = AutoEngine.new("Test", i)
    5.times {e.step}
    e.output.should eq("2")

    i[3,0] = Arithmetic.make(:i, 0, :*, :i, 0, :o, 0)
    e = AutoEngine.new("Test", i)
    5.times {e.step}
    e.output.should eq("200")

    i[3,0] = Arithmetic.make(:i, 0, :-, :i, 0, :o, 0)
    e = AutoEngine.new("Test", i)
    5.times {e.step}
    e.output.should eq("10")

    i[3,0] = Arithmetic.make(:i, 0, :==, :i, 0, :o, 0)
    e = AutoEngine.new("Test", i)
    5.times {e.step}
    e.output.should eq("0")

    i[3,0] = Arithmetic.make(:i, 0, :!=, :i, 0, :o, 0)
    e = AutoEngine.new("Test", i)
    5.times {e.step}
    e.output.should eq("1")

    i[3,0] = Arithmetic.make(:i, 0, :>, :i, 0, :o, 0)
    e = AutoEngine.new("Test", i)
    5.times {e.step}
    e.output.should eq("1")

    i[3,0] = Arithmetic.make(:i, 0, :<, :i, 0, :o, 0)
    e = AutoEngine.new("Test", i)
    5.times {e.step}
    e.output.should eq("0")

    i[3,0] = Arithmetic.make(:i, 0, :<, :i, 0, :o, 0)
    e = AutoEngine.new("Test", i)
    5.times {e.step}
    e.output.should eq("0")

    i[1,0] = Insert.make(2)
    i[3,0] = Arithmetic.make(:i, 0, :**, :i, 0, :o, 0)
    e = AutoEngine.new("Test", i)
    5.times {e.step}
    e.output.should eq("400")

    i[1,0] = Insert.make(1)
    i[2,0] = Insert.make(1)
    i[3,0] = Arithmetic.make(:i, 0, :&, :i, 0, :o, 0)
    e = AutoEngine.new("Test", i)
    5.times {e.step}
    e.output.should eq("1")

    i[1,0] = Insert.make(0)
    i[2,0] = Insert.make(1)
    i[3,0] = Arithmetic.make(:i, 0, :&, :i, 0, :o, 0)
    e = AutoEngine.new("Test", i)
    5.times {e.step}
    e.output.should eq("0")
  end
end
