require "spec"
require "../../src/pixel_lang_crystal"
require "../../src/pixel_lang_crystal/dev/helpers/**"

describe OutputChar do
  it "should end the program" do
    i = Instructions.new(3, 1)
    i[0,0] = Start.make(:right)
    i[1,0] = OutputChar.make('A')
    i[2,0] = End.make()

    e = AutoEngine.new("Test", i)
    2.times {e.step}
    e.ended?.should eq false
    e.step
    e.ended?.should eq true
    e.output.should eq "A"
  end
end
