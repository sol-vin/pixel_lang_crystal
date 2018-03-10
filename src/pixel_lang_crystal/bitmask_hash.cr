require "./bitmask"

module BitmaskHash
  getter masks : Hash(Symbol, Bitmask) = {} of Symbol => Bitmask  
  
  def [](key : Symbol)
    bitmask = @masks[key]
    (value & bitmask.mask) >> bitmask.shift
  end

  def []=(key : Symbol, v : UInt32)
    bitmask = @masks[key]
    v = (v % bitmask.max) << bitmask.shift

    # (2**bits - 1) << shift
    left_bits = 24 - bitmask.bits - bitmask.shift
    left_shift = bitmask.bits + bitmask.shift
    left_mask = (2**left_bits - 1) << left_shift
    right_mask = 2**(bitmask.shift) - 1

    left = @value & left_mask
    right = right_mask == 0 ? 0 : @value & right_mask
    self.value = left + v + right
  end

  def add_mask(name : Symbol, bits : Int, shift : Int)
    @masks[name] = Bitmask.new(bits.to_u8, shift.to_u8)
  end

  def to_bin
    value.to_s(2)
  end
end