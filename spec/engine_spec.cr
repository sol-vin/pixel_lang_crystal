require "spec"
require "../src/pixel_lang"

describe AutoEngine do
  it "should start" do
    e = AutoEngine.new("test", Instructions.new(10, 10))
  end

  it "should run a simple program" do
    i = Instructions.new(3, 1)
    i[0,0] = Start.new(C24.new(0x140000))
    #TODO: INVESTIGATE WHY THIS IS BROKEN!!!!!
    #       BitmaskHash#[]= report correct color 0x140000 in @value
    #       however from here it reports 0x100000
    #   -->   i[0,0].value[:direction] = 1_u32
    i[1,0] = OutputChar.new(C24.new(0xB00042))    
    i[2,0] = End.new(C24.new(0x0))
    e = AutoEngine.new("Test", i)
    e.pistons.size.should eq(1)
    e.run_one_instruction
    e.run_one_instruction
    e.run_one_instruction
    e.output.should eq("B")
  end
end