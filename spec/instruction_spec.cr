require "spec"
require "../src/pixel_lang"

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
end