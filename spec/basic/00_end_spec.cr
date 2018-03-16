require "spec"
require "../../src/pixel_lang_crystal"
require "../../src/pixel_lang_crystal/dev/helpers/**"

describe End do
  it "should end the program" do
    i = Instructions.new(3, 1)
    i[0,0] = Start.make(:right)
    i[2,0] = End.make()

    e = AutoEngine.new("Test", i)
    2.times {e.step}
    e.ended?.should eq false
    e.step
    e.ended?.should eq true
  end

  it "should end the program 2" do
    i = Instructions.new(7, 1)
    i[0,0] = Start.make(:right)
    i[6,0] = End.make()

    e = AutoEngine.new("Test", i)
    6.times {e.step}
    e.ended?.should eq false
    e.step
    e.ended?.should eq true
  end
end
