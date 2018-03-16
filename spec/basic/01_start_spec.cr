require "spec"
require "../../src/pixel_lang_crystal"
require "../../src/pixel_lang_crystal/dev/helpers/**"

describe Start do
  it "should start the program" do
    i = Instructions.new(2, 1)
    i[0,0] = Start.make(:right)
    i[1,0] = End.make()

    e = AutoEngine.new("Test", i)
    e.ended?.should eq false
  end

  it "should start multiple pistons" do
    i = Instructions.new(5, 1)
    i[0,0] = Start.make(:right)
    i[1,0] = Start.make(:right)
    i[2,0] = Start.make(:right)
    i[3,0] = Start.make(:right)
    i[4,0] = Start.make(:right)
    

    e = AutoEngine.new("Test", i)
    e.pistons.size.should eq 5
  end

  # TODO: Test priority
end
