# Basic constants used in various parts of the code.
module Constants
  TRUE = 1
  FALSE = 0
  BOOLEAN_OPERATIONS = [:<, :>, :<=, :>=, :==, :!=]
  ARITHMETIC_OPERATIONS = [:+, :-, :*, :/, :**, :&, :|, :^, :%]

  OPERATIONS = ARITHMETIC_OPERATIONS + BOOLEAN_OPERATIONS
  COLORS = ["red", "yellow", "green", "cyan", "blue", "magenta"]
end