require "./bitmask"

module BitmaskHash
  @masks : Hash(Symbol, Bitmask) = {} of Symbol => Bitmask  
  
  def [](key : Symbol)
    bitmask = @masks[key]
    (value & bitmask.mask) >> bitmask.shift
  end

  def add_mask(name : Symbol, bits : Int, shift : Int)
    @masks[name] = Bitmask.new(bits.to_u8, shift.to_u8)
  end
end