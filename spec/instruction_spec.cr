require "spec"
require "../src/pixel_lang_crystal"
require "../src/pixel_lang_crystal/dev/helpers/**"

describe Instructions do
  it "should correctly identify instructions" do
    Instruction.find_instruction(C24.new(0x000000)).should eq(End)
    Instruction.find_instruction(C24.new(0x100000)).should eq(Start)
    Instruction.find_instruction(C24.new(0x200000)).should eq(Pause)
    Instruction.find_instruction(C24.new(0x300000)).should eq(Direction)    
    Instruction.find_instruction(C24.new(0x400000)).should eq(Fork)
    Instruction.find_instruction(C24.new(0x500000)).should eq(Jump)
    Instruction.find_instruction(C24.new(0x600000)).should eq(Call)
    Instruction.find_instruction(C24.new(0x700000)).should eq(Conditional)
    Instruction.find_instruction(C24.new(0x800000)).should eq(Insert)
    Instruction.find_instruction(C24.new(0x900000)).should eq(Move)
    Instruction.find_instruction(C24.new(0xA00000)).should eq(Arithmetic)
    Instruction.find_instruction(C24.new(0xB00000)).should eq(OutputChar)
    Instruction.find_instruction(C24.new(0xF00000)).should eq(Blank)
  end

  it "should correctly instanciate instructions from find_instruction" do
    end_c24 = C24.new(0x000000)
    end_int = Instruction.find_instruction(end_c24).new end_c24
    end_int.value[:control_code].should eq(0)

    start_c24 = C24.new(0x100000)
    start_int = Instruction.find_instruction(start_c24).new start_c24
    start_int.value[:control_code].should eq(1)
    start_int.value[:direction].should eq(0)
    start_int.value[:priority].should eq(0)

    start_c24 = C24.new(0x100020)
    start_int = Instruction.find_instruction(start_c24).new start_c24
    start_int.value[:control_code].should eq(1)
    start_int.value[:direction].should eq(0)
    start_int.value[:priority].should eq(0x20)

  end
  
  it "should correctly store/read instructions" do
    i = Instructions.new(3, 1)
    i[0,0].value.value.should eq(0xFFFFFF)
    i[0,0].is_a?(Blank).should eq(true)
    i[0,0].value[:control_code].should eq(0xF)
    i[0,0] = Start.make(:right, 0)
    
    i[1,0] = OutputChar.new(C24.new(0xB00042))

    i[2,0] = End.new(C24.new(0x0))

    i[0,0].is_a?(Start).should eq(true)
    i[1,0].is_a?(OutputChar).should eq(true)
    i[1,0].value[:value].should eq(0x42)
    i[2,0].is_a?(End).should eq(true)

    c = StumpyCore::Canvas.new(3, 1)
    i.each do |x, y, i|
      c[x, y] = StumpyCore::RGBA.from_rgb8(i.value.r, i.value.g, i.value.b)
    end

    i2 = Instructions.new(c)
    i2[0,0].is_a?(Start).should eq(true)
    i2[1,0].is_a?(OutputChar).should eq(true)
    i2[2,0].is_a?(End).should eq(true)
  end
end