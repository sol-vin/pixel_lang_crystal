struct PistonMerge
  property piston : Piston
  property direction : Symbol
  property new_piston : Piston

  def initialize(@piston, @direction, @new_piston)
  end
end