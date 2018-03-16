require "spec"
require "../../src/pixel_lang_crystal"
require "../../src/pixel_lang_crystal/dev/helpers/**"

describe Pause do
  it "should pause a piston" do
    i = Instructions.new(3, 1)
    i[0,0] = Start.make(:right)
    i[1,0] = Pause.make()
    i[2,0] = End.make()

    e = AutoEngine.new("Test", i)
    3.times {e.step}
    e.ended?.should eq false
    e.step
    e.ended?.should eq true
  end

  it "should pause a piston for multiple cycles" do
    i = Instructions.new(3, 1)
    i[0,0] = Start.make(:right)
    i[1,0] = Pause.make(1)
    i[2,0] = End.make()

    e = AutoEngine.new("Test", i)
    4.times {e.step}
    e.ended?.should eq false
    e.step
    e.ended?.should eq true

    i = Instructions.new(3, 1)
    i[0,0] = Start.make(:right)
    i[1,0] = Pause.make(10)
    i[2,0] = End.make()

    e = AutoEngine.new("Test", i)
    13.times {e.step}
    e.ended?.should eq false
    e.step
    e.ended?.should eq true
  
    
    i = Instructions.new(3, 1)
    i[0,0] = Start.make(:right)
    i[1,0] = Pause.make(23)
    i[2,0] = End.make()

    e = AutoEngine.new("Test", i)
    26.times {e.step}
    e.ended?.should eq false
    e.step
    e.ended?.should eq true
  end
end
