require "spec"
require "../../src/pixel_lang_crystal"
require "../../src/pixel_lang_crystal/dev/helpers/**"

describe Fork do
  it "should fork pistons" do
    i = Instructions.new(3, 3)
    i[1,0] = Start.make(:down)
    i[1,1] = Fork.make(:left, :right)
    i[0,1] = End.make()
    i[2,1] = End.make()
    

    e = AutoEngine.new("Test", i)
    2.times {e.step}
    e.ended?.should eq false
    e.pistons.size.should eq 2    
    e.step
    e.ended?.should eq true

    i = Instructions.new(3, 3)
    i[0,1] = Start.make(:right)
    i[1,1] = Fork.make(:up, :down)
    i[1,0] = End.make()
    i[1,2] = End.make()
    

    e = AutoEngine.new("Test", i)
    2.times {e.step}
    e.ended?.should eq false
    e.pistons.size.should eq 2
    e.step
    e.ended?.should eq true

    i = Instructions.new(3, 3)
    i[0,1] = Start.make(:right)
    i[1,1] = Fork.make(:up, :down, :straight)
    i[1,0] = End.make()
    i[1,2] = End.make()
    i[2,1] = End.make()
    

    e = AutoEngine.new("Test", i)
    2.times {e.step}
    e.ended?.should eq false
    e.pistons.size.should eq 3
    e.step
    e.ended?.should eq true

    i = Instructions.new(3, 3)
    i[0,1] = Start.make(:right)
    i[1,1] = Fork.make(:up, :down, :straight)
    i[1,0] = End.make()
    i[1,2] = End.make()
    i[2,1] = End.make()
    

    e = AutoEngine.new("Test", i)
    2.times {e.step}
    e.ended?.should eq false
    e.pistons.size.should eq 3
    e.step
    e.ended?.should eq true
  end
end
