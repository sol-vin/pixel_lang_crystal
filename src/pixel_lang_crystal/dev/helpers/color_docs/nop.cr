# require "./../../../../basic/**"

# module NOP
#   def self.directions
#     i = []
#     i << Direction.make(:straight)
#     i
#   end

#   def self.calls
#     i = []
#     i << Call.make(:none, 0, 0)
#     i
#   end

#   def self.returns
#     i = []
#     i << Return.make(:none, false, false, false, :keep, :keep, false, false, false)
#     i
#   end

#   def self.moves
#     i = []
#     # Exclude o because moving to it will output and change state.
#     Piston::REGISTERS[0..6].each do |r|
#       i << Move.make(r, 0, r, 0)
#       i << Move.make(r, 0, r, 0, false, true)
#     end
    
#     i << Move.make(:o, 0, :i, 3)
#     i << Move.make(:o, 1, :i, 3)
#     i << Move.make(:o, 2, :i, 3)
#     i << Move.make(:o, 3, :i, 3)
    
    
#     #exclude i because swaping with i(0) as the source and destination will swap the values
#     Piston::REGULAR_REGISTERS.each do |r|
#       i << Move.make(r, 0, :i, 3) #anything into i null
#       [true, false].each do |swap|
#         [true, false].each do |reverse|
#           [0,2,3].each do |sop|
#             [0,2,3].each do |dop|
#               i << Move.make(r, sop, r, dop, swap, reverse)
#             end
#           end
#         end
#       end
#     end
#     i
#   end

#   def self.arithmetics
#     i = []
#     Piston::REGULAR_REGISTERS.each do |r|

#     end
#     i
#   end
# end