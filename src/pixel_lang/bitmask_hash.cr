require "./bitmask"

module BitmaskHash
  @masks : Hash(Symbol, Bitmask) = {} of Symbol => Bitmask  
  
  def [](key : Symbol)
    bitmask = @masks[key]
    (value & bitmask.mask) >> bitmask.shift
  end
  
  def add_mask(name : Symbol, bits : UInt8, shift : UInt8)
    @masks[name] = Bitmask.new(bits, shift)
  end
end