require "spec"
require "../../src/pixel_lang_crystal"
require "../../src/pixel_lang_crystal/dev/helpers/**"

describe Conditional do
  it "should work" do
    i = Instructions.new(3, 1)
    i[0,0] = Start.make(:right)
    i[1,0] = Conditional.make(:straight, :reverse, :ma, 0, :<, :mb, 0)
    i[2,0] = End.make()

    e = AutoEngine.new("Test", i)
    2.times {e.step}
    e.ended?.should eq false
    e.step
    e.ended?.should eq true

    i = Instructions.new(3, 1)
    i[0,0] = Start.make(:right)
    i[1,0] = Conditional.make(:straight, :reverse, :ma, 0, :>, :mb, 0)
    i[2,0] = End.make()

    e = AutoEngine.new("Test", i)
    4.times {e.step}
    e.ended?.should eq false
    e.step
    e.ended?.should eq false
  end

  it "should respect source order" do
    i = Instructions.new(5, 1)
    i[0,0] = Start.make(:right)
    i[1,0] = Insert.make(1)
    i[2,0] = Insert.make(2)
    i[3,0] = Conditional.make(:straight, :reverse, :i, 0, :>, :i, 0)
    i[4,0] = End.make()

    e = AutoEngine.new("Test", i)
    4.times {e.step}
    e.ended?.should eq false
    e.step
    e.ended?.should eq true

    i = Instructions.new(5, 1)
    i[0,0] = Start.make(:right)
    i[1,0] = Insert.make(1)
    i[2,0] = Insert.make(2)
    i[3,0] = Conditional.make(:straight, :reverse, :i, 0, :<, :i, 0)
    i[4,0] = End.make()

    e = AutoEngine.new("Test", i)
    4.times {e.step}
    e.ended?.should eq false
    e.step
    e.ended?.should eq false
  end
end
