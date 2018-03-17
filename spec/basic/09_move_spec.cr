require "spec"
require "../../src/pixel_lang_crystal"
require "../../src/pixel_lang_crystal/dev/helpers/**"

describe Move do
  it "should move registers" do
    i = Instructions.new(3, 1)
    i[0,0] = Start.make(:right)
    i[1,0] = Move.make(:mb, 0, :mav, 0)
    i[2,0] = End.make()

    e = AutoEngine.new("Test", i)
    p = e.pistons.first
    p.get_mav.should eq 0
    2.times {e.step}
    p.get_mav.should eq 1

    i[0,0] = Start.make(:right)
    i[1,0] = Move.make(:mb, 0, :ma, 0)
    i[2,0] = End.make()

    e = AutoEngine.new("Test", i)
    p = e.pistons.first
    p.get_ma.should eq 0
    2.times {e.step}
    p.get_ma.should eq 1

    i[0,0] = Start.make(:right)
    i[1,0] = Move.make(:mb, 0, :s, 0)
    i[2,0] = End.make()

    e = AutoEngine.new("Test", i)
    p = e.pistons.first
    p.get_s.should eq 0
    2.times {e.step}
    p.get_s.should eq 1
  end

  it "should swap values" do
    i = Instructions.new(3, 1)
    i[0,0] = Start.make(:right)
    i[1,0] = Move.make(:mb, 0, :ma, 0, true)
    i[2,0] = End.make()

    e = AutoEngine.new("Test", i)
    p = e.pistons.first
    p.get_ma.should eq 0
    p.get_mb.should eq 1
    2.times {e.step}
    p.get_ma.should eq 1
    p.get_mb.should eq 0

    i = Instructions.new(3, 1)
    i[0,0] = Start.make(:right)
    i[1,0] = Move.make(:mbv, 0, :mb, 0, true)
    i[2,0] = End.make()

    e = AutoEngine.new("Test", i)
    p = e.pistons.first
    p.get_mb.should eq 1
    p.get_mbv.should eq 0
    2.times {e.step}
    p.get_mb.should eq 0
    p.get_mbv.should eq 1
  end

  it "should swap i stack items" do
    i = Instructions.new(7, 1)
    i[0,0] = Start.make(:right)
    i[1,0] = Insert.make(0x12345)
    i[2,0] = Insert.make(0x67890)
    i[3,0] = Move.make(:i, 0, :i, 0, true)
    i[4,0] = Move.make(:i, 0, :o, 2)
    i[5,0] = Move.make(:i, 0, :o, 2)    
    i[6,0] = End.make()

    e = AutoEngine.new("Test", i)
    p = e.pistons.first
    7.times {e.step}
    e.ended?.should eq true
    e.output.should eq "1234567890"
  end

  it "should swap i stack items" do
    i = Instructions.new(7, 1)
    i[0,0] = Start.make(:right)
    i[1,0] = Insert.make(0x12345)
    i[2,0] = Insert.make(0x67890)
    i[3,0] = Move.make(:i, 0, :i, 0, true)
    i[4,0] = Move.make(:i, 0, :o, 2)
    i[5,0] = Move.make(:i, 0, :o, 2)    
    i[6,0] = End.make()

    e = AutoEngine.new("Test", i)
    p = e.pistons.first
    7.times {e.step}
    e.ended?.should eq true
    e.output.should eq "1234567890"
  end

  it "should output last output" do
    i = Instructions.new(7, 2)
    i[0,0] = Start.make(:right)
    i[1,0] = Insert.make(0x12345)
    i[2,0] = Move.make(:i, 0, :o, 2)
    i[3,0] = Move.make(:o, 0, :o, 2)
    i[4,0] = Pause.make()
    i[5,0] = Move.make(:o, 0, :o, 2)
    i[6,0] = End.make()

    i[0,1] = Start.make(:right)
    i[1,1] = Insert.make(0x67890)
    i[4,1] = Move.make(:i, 0, :o, 2)
    i[6,1] = End.make()
    
    e = AutoEngine.new("Test", i)
    p = e.pistons.first
    8.times {e.step}
    e.ended?.should eq true
    e.output.should eq "12345123456789067890"

    i = Instructions.new(4, 1)
    i[0,0] = Start.make(:right)
    i[1,0] = OutputChar.make '?'
    i[2,0] = Move.make(:o, 1, :o, 1)
    i[3,0] = End.make()

    e = AutoEngine.new("Test", i)
    4.times {e.step}
    e.ended?.should eq true
    e.output.should eq "??"
  end

  it "should throw things away through i null" do
    i = Instructions.new(4, 1)
    i[0,0] = Start.make(:right)
    i[1,0] = Insert.make(0x666)
    i[2,0] = Move.make(:i, 0, :i, 3)
    i[3,0] = End.make()

    e = AutoEngine.new("Test", i)
    p = e.pistons.first
    2.times {e.step}
    p.i.size.should eq 1
    e.step
    p.i.size.should eq 0
    e.step
    e.ended?.should eq true
  end
end
