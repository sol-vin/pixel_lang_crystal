# Basic constants used in various parts of the code.
module Constants
  TRUE = 1
  FALSE = 0
  BOOLEAN_OPERATIONS = [:<, :>, :<=, :>=, :==, :!=]
  ARITHMETIC_OPERATIONS = [:+, :-, :*, :/, :**, :&, :|, :^, :%]
  BASIC_DIRECTIONS = [:up, :right, :down, :left]
  DIRECTIONS = BASIC_DIRECTIONS + [:turn_left, :turn_right, :reverse, :random]
  OPERATIONS = ARITHMETIC_OPERATIONS + BOOLEAN_OPERATIONS
  COLORS = ["red", "yellow", "green", "cyan", "blue", "magenta"]
end