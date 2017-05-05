class Matrix2(T)
  include Enumerable(T)
  getter size_x : Int32
  getter size_y : Int32

  getter buffer : Slice(T)
  
  def initialize(@size_x : Int32, @size_y : Int32)
    @buffer = Slice(T).new(size_x * size_y) {yield.as(T)}
  end

  def [](x, y)
    raise IndexError.new unless check_bounds(x, y)
    @buffer[@size_x * y + x]
  end
  
  def []=(x, y, value : T)
    raise IndexError.new unless check_bounds(x, y)  
    @buffer[@size_x * y + x] = value
  end

  def each
    size_x.times do |x|
      size_y.times do |y|
        yield @buffer[x, y]
      end
    end
  end

  def check_bounds(x : Int32, y : Int32) : Bool
    !(x < 0 || x >= size_x || y < 0 || y >= size_y)
  end
end