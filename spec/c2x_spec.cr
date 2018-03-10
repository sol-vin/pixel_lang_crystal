require "spec"
require "../src/pixel_lang_crystal/c20"
require "../src/pixel_lang_crystal/c24"


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

  it "should be able to use +" do
    c1, c2 = C20.new(1), C20.new(4)
    c3 = c1 + c2
    c3.value.should eq(5)

    c1, c2 = C20.new(8), C20.new(2008)
    c3 = c1 + c2
    c3.value.should eq(2016)

    c1, c2 = C20.new(200), C20.new(1024)
    c3 = c1 + c2
    c3.value.should eq(1224)

    c1, c2 = C20.new(99), C20.new(1)
    c3 = c1 + c2
    c3.value.should eq(100)
  end

  it "should be able to use -" do
    c1, c2 = C20.new(1), C20.new(4)
    c3 = c1 - c2
    c3.value.should eq(C20::MAX-3)

    c1, c2 = C20.new(8), C20.new(2008)
    c3 = c1 - c2
    c3.value.should eq(C20::MAX-2000)

    c1, c2 = C20.new(200), C20.new(1024)
    c3 = c1 - c2
    c3.value.should eq(C20::MAX-824)

    c1, c2 = C20.new(99), C20.new(1)
    c3 = c1 - c2
    c3.value.should eq(98)

    c1, c2 = C20.new(99), C20.new(98)
    c3 = c1 - c2
    c3.value.should eq(1)

    c1, c2 = C20.new(1024), C20.new(200)
    c3 = c1 - c2
    c3.value.should eq(824)
  end

  it "should be able to use *" do
    c1, c2 = C20.new(1), C20.new(4)
    c3 = c1 * c2
    c3.value.should eq(4)

    c1, c2 = C20.new(8), C20.new(2008)
    c3 = c1 * c2
    c3.value.should eq(2008*8)

    c1, c2 = C20.new(2), C20.new(1024)
    c3 = c1 * c2
    c3.value.should eq(2048)

    c1, c2 = C20.new(5), C20.new(2)
    c3 = c1 * c2
    c3.value.should eq(10)
  end

  it "should be able to use /" do
    c1, c2 = C20.new(15), C20.new(3)
    c3 = c1 / c2
    c3.value.should eq(5)

    c1, c2 = C20.new(25), C20.new(5)
    c3 = c1 / c2
    c3.value.should eq(5)

    c1, c2 = C20.new(20), C20.new(2)
    c3 = c1 / c2
    c3.value.should eq(10)

    c1, c2 = C20.new(2000), C20.new(200)
    c3 = c1 / c2
    c3.value.should eq(10)
  end

  it "should be able to use ==" do
    c1, c2 = C20.new(1), C20.new(4)
    (c1 == c2).should eq(false)

    c1, c2 = C20.new(4), C20.new(4)
    (c1 == c2).should eq(true)

    c1, c2 = C20.new(200), C20.new(2)
    (c1 == c2).should eq(false)

    c1, c2 = C20.new(2), C20.new(6784)
    (c1 == c2).should eq(false)

    c1, c2 = C20.new(6784), C20.new(6784)
    (c1 == c2).should eq(true)
  end

  it "should be able to use >" do
    c1, c2 = C20.new(1), C20.new(4)
    (c1 > c2).should eq(false)

    c1, c2 = C20.new(4), C20.new(4)
    (c1 > c2).should eq(false)

    c1, c2 = C20.new(200), C20.new(2)
    (c1 > c2).should eq(true)

    c1, c2 = C20.new(2), C20.new(6784)
    (c1 > c2).should eq(false)

    c1, c2 = C20.new(6784), C20.new(6784)
    (c1 > c2).should eq(false)
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

  it "should provide bitmask get" do
    c = C24.new(0)
    c[:value].should eq(0)

    c = C24.new(100)
    c[:value].should eq(100)
  end

  it "should provide bitmask set" do
    c = C24.new(0)
    c[:value].should eq(0)
    c[:value] = 100_u32
    c[:value].should eq(100)

    c.add_mask(:upper_10, 10, 10)
    c.add_mask(:lower_10, 10, 0)

    c[:upper_10].should eq(0)
    c[:lower_10].should eq(100)
    
    c[:upper_10] = 1_u32
    c[:upper_10].should eq(1)

    c[:upper_10] = 0_u32
    c[:upper_10].should eq(0)

    c[:upper_10] = 10_u32
    c[:upper_10].should eq(10)

    c[:upper_10] = 1_u32
    c[:upper_10] = 43_u32
    c[:upper_10].should eq(43)

    c[:upper_10] = 128_u32
    c[:upper_10].should eq(128)

    c[:lower_10] = 1_u32
    c[:lower_10].should eq(1)
    
    c[:lower_10] = 3_u32
    c[:lower_10].should eq(3)

    c[:lower_10] = 100_u32
    c[:lower_10].should eq(100)

    c[:lower_10] = 345_u32
    c[:lower_10].should eq(345)

    c[:lower_10] = 1000_u32
    c[:lower_10].should eq(1000)

    c[:upper_10] = 45_u32
    c[:lower_10] = 99_u32
    c[:lower_10].should eq(99)

    c[:upper_10] = 145_u32
    c[:lower_10] = 120_u32
    c[:lower_10].should eq(120)

    c[:upper_10] = 1003_u32
    c[:lower_10] = 99_u32
    c[:lower_10].should eq(99)

    c[:lower_10] = 45_u32
    c[:upper_10] = 99_u32
    c[:upper_10].should eq(99)

    c[:lower_10] = 145_u32
    c[:upper_10] = 199_u32
    c[:upper_10].should eq(199)

    c[:lower_10] = 1003_u32
    c[:upper_10] = 93_u32
    c[:upper_10].should eq(93)
  end
end