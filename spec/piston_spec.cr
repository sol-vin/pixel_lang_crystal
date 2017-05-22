require "spec"
require "../src/pixel_lang_crystal"

describe Piston do
  it "should move right" do
    i = Instructions.new(3, 1)

    s = Start.new(C24.new(0x100000))
    s.value[:direction] = 1_u32    
    i[0,0] = s
    i[1,0] = Blank.new(C24.new(0xFFFFFF))    
    i[2,0] = End.new(C24.new(0x000000))

    e = AutoEngine.new("Test", i)

    e.pistons[0].position_x.should eq(0)
    e.pistons[0].position_y.should eq(0)

    e.run_one_instruction

    e.pistons[0].position_x.should eq(1)
    e.pistons[0].position_y.should eq(0)

    e.run_one_instruction

    e.pistons[0].position_x.should eq(2)
    e.pistons[0].position_y.should eq(0)
  end

  it "should move left" do
    i = Instructions.new(3, 1)

    s = Start.new(C24.new(0x100000))
    s.value[:direction] = 3_u32    
    i[2,0] = s
    i[1,0] = Blank.new(C24.new(0xFFFFFF))    
    i[0,0] = End.new(C24.new(0x000000))

    e = AutoEngine.new("Test", i)

    e.pistons[0].position_x.should eq(2)
    e.pistons[0].position_y.should eq(0)

    e.run_one_instruction

    e.pistons[0].position_x.should eq(1)
    e.pistons[0].position_y.should eq(0)

    e.run_one_instruction

    e.pistons[0].position_x.should eq(0)
    e.pistons[0].position_y.should eq(0)
  end

  it "should move down" do
    i = Instructions.new(1, 3)

    s = Start.new(C24.new(0x100000))
    s.value[:direction] = 2_u32    
    i[0,0] = s
    i[0,1] = Blank.new(C24.new(0xFFFFFF))    
    i[0,2] = End.new(C24.new(0x000000))

    e = AutoEngine.new("Test", i)

    e.pistons[0].position_x.should eq(0)
    e.pistons[0].position_y.should eq(0)

    e.run_one_instruction

    e.pistons[0].position_x.should eq(0)
    e.pistons[0].position_y.should eq(1)

    e.run_one_instruction

    e.pistons[0].position_x.should eq(0)
    e.pistons[0].position_y.should eq(2)
  end

  it "should move up" do
    i = Instructions.new(1, 3)

    s = Start.new(C24.new(0x100000))
    s.value[:direction] = 0_u32    
    i[0,2] = s
    i[0,1] = Blank.new(C24.new(0xFFFFFF))    
    i[0,0] = End.new(C24.new(0x000000))

    e = AutoEngine.new("Test", i)

    e.pistons[0].position_x.should eq(0)
    e.pistons[0].position_y.should eq(2)

    e.run_one_instruction

    e.pistons[0].position_x.should eq(0)
    e.pistons[0].position_y.should eq(1)

    e.run_one_instruction

    e.pistons[0].position_x.should eq(0)
    e.pistons[0].position_y.should eq(0)
  end

  it "should change ma" do
    i = Instructions.new(4, 1)

    s = Start.new(C24.new(0x100000))
    s.value[:direction] = 1_u32    
    i[0,0] = s
    i[1,0] = Arithmetic.make(:mb, 0, :+, :mb, 0, :ma, 0)
    i[2,0] = Move.make(:ma, 0, :o, 0)
    i[3,0] = End.new(C24.new(0x000000))

    e = AutoEngine.new("Test", i)
    e.run
    e.output.should eq("2")
  end

  it "should swap ma and mb" do
    i = Instructions.new(6, 1)

    s = Start.new(C24.new(0x100000))
    s.value[:direction] = 1_u32    
    i[0,0] = s
    i[1,0] = Arithmetic.make(:mb, 0, :+, :mb, 0, :ma, 0)
    i[2,0] = Move.make(:ma, 0, :mb, 0, true)
    i[3,0] = Move.make(:ma, 0, :o, 0)
    i[4,0] = Move.make(:mb, 0, :o, 0)
    i[5,0] = End.new(C24.new(0x000000))

    e = AutoEngine.new("Test", i)
    e.run
    e.output.should eq("12")
  end

  it "should swap mav and mbv" do
    i = Instructions.new(7, 1)

    s = Start.new(C24.new(0x100000))
    s.value[:direction] = 1_u32    
    i[0,0] = s
    i[1,0] = Arithmetic.make(:mb, 0, :+, :mb, 0, :mav, 0)
    i[2,0] = Move.make(:mb, 0, :mbv, 0)    
    i[3,0] = Move.make(:mav, 0, :mbv, 0, true)
    i[4,0] = Move.make(:mav, 0, :o, 0)
    i[5,0] = Move.make(:mbv, 0, :o, 0)
    i[6,0] = End.new(C24.new(0x000000))

    e = AutoEngine.new("Test", i)
    e.run
    e.output.should eq("12")
  end

  it "should stack i" do
    i = Instructions.new(12, 1)

    s = Start.new(C24.new(0x100000))
    s.value[:direction] = 1_u32    
    i[0,0] = s
    i[1,0] = Insert.new(C24.new(0x800001))
    i[2,0] = Insert.new(C24.new(0x800002))
    i[3,0] = Insert.new(C24.new(0x800003))
    i[4,0] = Insert.new(C24.new(0x800004))
    i[5,0] = Move.make(:i, 2, :o, 0)
    i[6,0] = Move.make(:i, 0, :o, 0)
    i[7,0] = Move.make(:i, 0, :o, 0)
    i[8,0] = Move.make(:i, 0, :o, 0)
    i[9,0] = Move.make(:i, 2, :o, 0)    
    i[10,0] = Move.make(:i, 0, :o, 0)
    i[11,0] = End.new(C24.new(0x000000))

    e = AutoEngine.new("Test", i)
    e.run
    e.output.should eq("443211")
  end
end