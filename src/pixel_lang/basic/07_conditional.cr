require './../instruction'
require './../piston'

class Conditional < Instruction
  def self.control_code
    0x7
  end

  TYPES = [:vertical, :horizontal, :reverse_vertical, :reverse_horizontal,
           :pass_through, :gate, :turn_left, :turn_right,
           :straight_or_left, :straight_or_right, :left_or_straight, :right_or_straight]

  # Metric ass ton of procs efining how to piston (p) should move
  DIRECTIONS = {
      # NAME: [FALSE_PROC, TRUE_PROC]
      vertical: [-> p { p.change_direction :up }, -> p { p.change_direction :down }],
      reverse_vertical: [-> p { p.change_direction :down }, -> p { p.change_direction :up }],
      horizontal: [-> p { p.change_direction :left }, -> p { p.change_direction :right }],
      reverse_horizontal: [-> p { p.change_direction :right }, -> p { p.change_direction :left }],
      pass_through: [-> p { }, -> p { p.reverse }],
      gate: [-> p { p.reverse }, -> p { }],
      turn_left: [-> p { p.turn_right }, -> p { p.turn_left }],
      turn_right: [-> p { p.turn_left }, -> p { p.turn_right }],
      straight_or_left: [-> p { p.turn_left }, -> p { }],
      straight_or_right: [-> p { p.turn_right }, -> p { }],
      left_or_straight: [ -> p { }, -> p { p.turn_left }],
      right_or_straight: [-> p { }, -> p { p.turn_right }],
  }

  TYPE_BITS = 6
  TYPE_BITSHIFT = 14

  SOURCE_1_BITS = 3
  SOURCE_1_BITSHIFT = 11

  SOURCE_1_OPTIONS_BITS = 2
  SOURCE_1_OPTIONS_BITSHIFT = 9

  OPERATION_BITS = 4
  OPERATIONS_BITSHIFT = 5

  SOURCE_2_BITS = 3
  SOURCE_2_BITSHIFT = 2

  SOURCE_2_OPTIONS_BITS = 2
  SOURCE_2_OPTIONS_BITSHIFT = 0

  def self.reference_card
    puts %q{
    Conditional Instruction
    Evaluates an arithmetic expression. If the result is zero, the piston moves one way, else, it moves another.
     0bCCCCTTTTTT111XXAAAA222YY
     C = Control Code (Instruction) [4 bits]
     T = Type [6 bit]
     1 = Source 1 Register [3 bits]
     X = Source 1 options [2 bits]
     A = Arithmatic Operation [4 bits] (See Arithmetic::OPERATIONS)
     2 = Source 2 Register [3 bits]
     Y = Source 2 options [2 bits]
    }
  end

  def self.make_color(type, s1, s1op, op, s2, s2op)
    type_bits = TYPES.index(type) << TYPE_BITSHIFT
    s1_bits = Piston::REGISTERS.index(s1) << SOURCE_1_BITSHIFT
    s1op_bits = s1op << SOURCE_1_OPTIONS_BITSHIFT
    op_bits = Arithmetic::OPERATIONS.index(op) << OPERATIONS_BITSHIFT
    s2_bits = Piston::REGISTERS.index(s2) << SOURCE_2_BITSHIFT
    s2op_bits = s2op << SOURCE_2_OPTIONS_BITSHIFT

    ((control_code << CONTROL_CODE_BITSHIFT) + type + s1 + s1op + op + s2 + s2op).to_s 16
  end

  def self.run(piston, *args)
    type = args[0]
    s1 = args[1]
    s1op = args[2]
    op = args[3]
    s2 = args[4]
    s2op = args[5]

    v1 = piston.send(s1, s1op)
    v2 = piston.send(s2, s2op)

    result = v1.send(op, v2)

    if result == LOGICAL_FALSE || !result
      DIRECTIONS[type][0][piston]
    else
      DIRECTIONS[type][1][piston]
    end
  end
end