require "spec"
require "../src/pixel_lang/c20"
require "../src/pixel_lang/c24"


describe C20 do
  it "should store value" do
    C20.new(100).value.should eq(100)
    C20.new(1000).value.should eq(1000)
    C20.new(10000).value.should eq(10000)
    C20.new(100000).value.should eq(100000)
    C20.new(6543).value.should eq(6543)
    C20.new(1).value.should eq(1)
  end

  it "should roll value over" do
    C20.new(C20::MAX).value.should eq(0)
    c = C20.new(C20::MAX-1)
    c += 1
    c.value.should eq(0)
  end

  it "should roll value under" do
    C20.new(-1).value.should eq(C20::MAX-1)
    c = C20.new(0)
    c -= 1
    c.value.should eq(C20::MAX-1)
  end
end

describe C24 do
  it "should store value" do
    C24.new(100).value.should eq(100)
    C24.new(1000).value.should eq(1000)
    C24.new(10000).value.should eq(10000)
    C24.new(100000).value.should eq(100000)
    C24.new(6543).value.should eq(6543)
    C24.new(1).value.should eq(1)
  end

  it "should roll value over" do
    C24.new(C24::MAX).value.should eq(0)
    c = C24.new(C24::MAX-1)
    c += 1
    c.value.should eq(0)
  end

    it "should roll value under" do
    C24.new(-1).value.should eq(C24::MAX-1)
    c = C24.new(0)
    c -= 1
    c.value.should eq(C24::MAX-1)
  end
end