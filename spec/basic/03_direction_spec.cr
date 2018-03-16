require "spec"
require "../../src/pixel_lang_crystal"
require "../../src/pixel_lang_crystal/dev/helpers/**"

describe Direction do
  it "should change the piston left" do
    i = Instructions.new(3, 3)
    i[2,0] = Start.make(:down)
    i[2,1] = Direction.make(:left)
    i[1,1] = End.make()

    e = AutoEngine.new("Test", i)
    2.times {e.step}
    e.ended?.should eq false
    e.step
    e.ended?.should eq true
  end

  it "should change the piston right" do
    i = Instructions.new(3, 3)
    i[0,0] = Start.make(:down)
    i[0,1] = Direction.make(:right)
    i[1,1] = End.make()

    e = AutoEngine.new("Test", i)
    2.times {e.step}
    e.ended?.should eq false
    e.step
    e.ended?.should eq true
  end

  it "should change the piston up" do
    i = Instructions.new(3, 3)
    i[0,2] = Start.make(:right)
    i[1,2] = Direction.make(:up)
    i[1,1] = End.make()

    e = AutoEngine.new("Test", i)
    2.times {e.step}
    e.ended?.should eq false
    e.step
    e.ended?.should eq true
  end

  it "should change the piston down" do
    i = Instructions.new(3, 3)
    i[0,0] = Start.make(:right)
    i[1,0] = Direction.make(:down)
    i[1,1] = End.make()

    e = AutoEngine.new("Test", i)
    2.times {e.step}
    e.ended?.should eq false
    e.step
    e.ended?.should eq true
  end

  it "should turn the piston right" do
    i = Instructions.new(3, 3)
    i[0,0] = Start.make(:right)
    i[1,0] = Direction.make(:turn_right)
    i[1,1] = End.make()

    e = AutoEngine.new("Test", i)
    2.times {e.step}
    e.ended?.should eq false
    e.step
    e.ended?.should eq true
  end

  it "should turn the piston left" do
    i = Instructions.new(3, 3)
    i[0,2] = Start.make(:right)
    i[1,2] = Direction.make(:turn_left)
    i[1,1] = End.make()

    e = AutoEngine.new("Test", i)
    2.times {e.step}
    e.ended?.should eq false
    e.step
    e.ended?.should eq true
  end
end
