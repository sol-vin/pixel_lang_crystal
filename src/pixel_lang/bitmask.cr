struct Bitmask
  property bits : UInt8
  property shift : UInt8
  
  def initialize(@bits : UInt8, @shift : UInt8)
  end
  
  def mask
    (2**bits - 1) << shift
  end
end
