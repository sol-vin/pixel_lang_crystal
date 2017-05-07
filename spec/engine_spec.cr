require "spec"
require "../src/pixel_lang"

describe AutoEngine do
  it "should start" do
    e = AutoEngine.new("test", Instructions.new(10, 10))
  end
end