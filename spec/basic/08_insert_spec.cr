require "spec"
require "../../src/pixel_lang_crystal"
require "../../src/pixel_lang_crystal/dev/helpers/**"

describe Insert do
  it "should insert values correctly" do
    i = Instructions.new(11, 1)
    i[0,0] = Start.make(:right)
    i[1,0] = Insert.make(0x12345)
    i[2,0] = Insert.make(0x67890)
    i[3,0] = Insert.make(0xABCDE)
    i[4,0] = Move.make(:i, 0, :ma, 0)
    i[5,0] =  Move.make(:i, 0, :mb, 0)
    i[6,0] =  Move.make(:i, 0, :s, 0)
    i[7,0] =  Move.make(:s, 0, :o, 2)
    i[8,0] =  Move.make(:mb, 0, :o, 2)
    i[9,0] =  Move.make(:ma, 0, :o, 2)
    i[10,0] = End.make()

    e = AutoEngine.new("Test", i)
    11.times {e.step}
    e.ended?.should eq true
    e.output.should eq ("1234567890ABCDE")
  end
end
