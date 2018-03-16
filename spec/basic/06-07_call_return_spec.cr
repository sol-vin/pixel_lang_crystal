require "spec"
require "../../src/pixel_lang_crystal"
require "../../src/pixel_lang_crystal/dev/helpers/**"

describe Call do
  it "should pass general test" do
    i = Instructions.new(4, 3)
    i[0,0] = Start.make(:right)
    i[1,0] = Call.make(:push, -1, 1)
    i[2,0] = Return.make(:pop, false, false, false, :keep, :keep, true, true, true)
    i[3,0] = End.make()
    i[0,1] = OutputChar.make('!')
    i[1,1] = Direction.make(:down)
    i[1,2] = Return.make(:peek, false, false, false, :keep, :keep, true, true, true)
    
    

    e = AutoEngine.new("Test", i)
    p = e.pistons.first

    e.step
    p.call_stack.empty?.should eq true
    e.step
    p.call_stack.size.should eq 1
    p.x.should eq 0
    p.y.should eq 1
    e.output.should eq ""
    e.step
    e.output.should eq "!"
    e.step
    p.direction.should eq :down
    e.step
    p.call_stack.size.should eq 1
    p.x.should eq 2
    p.y.should eq 0
    e.step
    p.call_stack.size.should eq 0
    p.x.should eq 2
    p.y.should eq 0
    e.step
    e.step
    e.ended?.should eq true
  end

  it "should copy registers" do
    i = Instructions.new(8, 1)
    i[0,0] = Start.make(:right)
    i[1,0] = Insert.make(1234)
    i[2,0] = Move.make(:i, 0, :ma, 0)
    i[3,0] = Call.make(:push, 1, 0)
    i[4,0] = Move.make(:mb, 0, :ma, 0)
    i[5,0] = Return.make(:pop, true, false, false, :keep, :keep, false, false, false)
    i[6,0] = Move.make(:ma, 0, :o, 0)
    i[7,0] = End.make()
    
    e = AutoEngine.new("Test", i)
    p = e.pistons.first
    
    e.step
    e.step
    e.step
    e.step
    p.ma.should eq 1234
    e.step
    p.ma.should eq 1
    e.step
    p.ma.should eq 1234

    i = Instructions.new(8, 1)
    i[0,0] = Start.make(:right)
    i[1,0] = Insert.make(1234)
    i[2,0] = Move.make(:i, 0, :mb, 0)
    i[3,0] = Call.make(:push, 1, 0)
    i[4,0] = Move.make(:ma, 0, :mb, 0)
    i[5,0] = Return.make(:pop, false, true, false, :keep, :keep, false, false, false)
    i[6,0] = Move.make(:mb, 0, :o, 0)
    i[7,0] = End.make()
    
    e = AutoEngine.new("Test", i)
    p = e.pistons.first
    
    e.step
    e.step
    e.step
    e.step
    p.mb.should eq 1234
    e.step
    p.mb.should eq 0
    e.step
    p.mb.should eq 1234

    i = Instructions.new(8, 1)
    i[0,0] = Start.make(:right)
    i[1,0] = Insert.make(1234)
    i[2,0] = Move.make(:i, 0, :s, 0)
    i[3,0] = Call.make(:push, 1, 0)
    i[4,0] = Move.make(:ma, 0, :s, 0)
    i[5,0] = Return.make(:pop, false, false, true, :keep, :keep, false, false, false)
    i[6,0] = Move.make(:s, 0, :o, 0)
    i[7,0] = End.make()
    
    e = AutoEngine.new("Test", i)
    p = e.pistons.first
    
    e.step
    e.step
    e.step
    e.step
    p.s.should eq 1234
    e.step
    p.s.should eq 0
    e.step
    p.s.should eq 1234
  end

  it "should copy i stack" do
    i = Instructions.new(12, 1)
    i[0,0] = Start.make(:right)
    i[1,0] = Insert.make(12)
    i[2,0] = Insert.make(34)
    i[3,0] = Insert.make(56)
    i[4,0] = Insert.make(78)
    i[5,0] = Call.make(:push, 1, 0)
    i[6,0] = Move.make(:i, 0, :i, 3)
    i[7,0] = Move.make(:i, 0, :i, 3)
    i[8,0] = Move.make(:i, 0, :i, 3)
    i[9,0] = Move.make(:i, 0, :i, 3)
    i[10,0] = Return.make(:pop, false, false, false, :restore, :keep, false, false, false)
    i[11,0] = End.make()

    e = AutoEngine.new("Test", i)
    p = e.pistons.first
    
    p.current_instruction.class.should eq Start
    e.step # Start
    p.i.size.should eq 0
    p.current_instruction.class.should eq Insert
    e.step # Insert
    p.i.size.should eq 1
    p.current_instruction.class.should eq Insert
    e.step # Insert
    p.i.size.should eq 2
    p.current_instruction.class.should eq Insert
    e.step # Insert
    p.i.size.should eq 3
    p.current_instruction.class.should eq Insert
    e.step # Insert
    p.i.size.should eq 4
    p.current_instruction.class.should eq Call
    e.step # Call
    p.i.size.should eq 4
    p.current_instruction.class.should eq Move
    first = p.i[0]
    e.step # Move
    p.i.size.should eq 3
    p.current_instruction.class.should eq Move
    e.step # Move
    p.i.size.should eq 2
    p.current_instruction.class.should eq Move
    e.step # Move
    p.i.size.should eq 1    
    p.current_instruction.class.should eq Move
    e.step # Move
    p.i.size.should eq 0
    e.step
    p.i.size.should eq 4
    first.should eq p.i[0]
  end

  it "should copy memory" do
    i = Instructions.new(12, 1)
    i[0,0] = Start.make(:right)
    i[1,0] = Insert.make(1234)
    i[2,0] = Insert.make(5678)
    i[3,0] = Move.make(:i, 0, :mbv, 0)
    i[4,0] = Move.make(:i, 0, :mav, 0)
    i[5,0] = Call.make(:push, 1, 0)
    i[6,0] = Move.make(:ma, 0, :mav, 0)
    i[7,0] = Move.make(:ma, 0, :mbv, 0)
    i[8,0] = Return.make(:pop, false, false, false, :keep, :restore, false, false, false)
    i[9,0] = Move.make(:mav, 0, :o, 0)
    i[10,0] = Move.make(:mbv, 0, :o, 0)
    i[11,0] = End.make()

    e = AutoEngine.new("Test", i)
    p = e.pistons.first
    6.times {e.step}
    p.get_mav(0).should eq 1234
    p.get_mbv(0).should eq 5678
    2.times {e.step}
    p.get_mav(0).should eq 0
    p.get_mbv(0).should eq 0
    3.times {e.step}
    e.output.should eq "12345678"
  end
end
