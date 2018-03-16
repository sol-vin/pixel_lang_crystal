require "spec"
require "../../src/pixel_lang_crystal"
require "../../src/pixel_lang_crystal/dev/helpers/**"

describe Jump do
  it "should jump over an instruction" do
    i = Instructions.new(4, 1)
    i[0,0] = Start.make(:right)
    i[1,0] = Jump.make()
    i[2,0] = OutputChar.make('!')
    i[3,0] = End.make()

    e = AutoEngine.new("Test", i)
    2.times {e.step}
    e.ended?.should eq false
    e.step
    e.ended?.should eq true
    e.output.empty?.should eq true
  end

  it "should jump over multiple instructions!" do
    i = Instructions.new(8, 1)
    i[0,0] = Start.make(:right)
    i[1,0] = Jump.make(4)
    i[2,0] = OutputChar.make('!')
    i[3,0] = OutputChar.make('@')
    i[4,0] = OutputChar.make('#')
    i[5,0] = OutputChar.make('$')
    i[6,0] = OutputChar.make('%')
    i[7,0] = End.make()

    e = AutoEngine.new("Test", i)
    2.times {e.step}
    e.ended?.should eq false
    e.step
    e.ended?.should eq true
    e.output.empty?.should eq true
  end

  it "should jump over multiple instructions and wrap" do
    i = Instructions.new(8, 1)
    i[0,0] = Start.make(:right)
    i[1,0] = Jump.make(4 + 16)
    i[2,0] = OutputChar.make('!')
    i[3,0] = OutputChar.make('@')
    i[4,0] = OutputChar.make('#')
    i[5,0] = OutputChar.make('$')
    i[6,0] = OutputChar.make('%')
    i[7,0] = End.make()

    e = AutoEngine.new("Test", i)
    2.times {e.step}
    e.ended?.should eq false
    e.step
    e.ended?.should eq true
    e.output.empty?.should eq true

    i = Instructions.new(8, 1)
    i[7,0] = Start.make(:left)
    i[6,0] = Jump.make(4 + 16)
    i[5,0] = OutputChar.make('!')
    i[4,0] = OutputChar.make('@')
    i[3,0] = OutputChar.make('#')
    i[2,0] = OutputChar.make('$')
    i[1,0] = OutputChar.make('%')
    i[0,0] = End.make()

    e = AutoEngine.new("Test", i)
    2.times {e.step}
    e.ended?.should eq false
    e.step
    e.ended?.should eq true
    e.output.empty?.should eq true
  end
end
