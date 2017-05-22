require "./../instruction"
require "./../piston"

class Direction < Instruction
  DIRECTIONS = Piston::DIRECTIONS + [:turn_left, :turn_right, :reverse, :random]

  def self.control_code
    0x3
  end

  def self.reference_card
    puts %q{
    Direction Instruction
    Tells a piston to change direction
    0bCCCC0000000000000000DDDD
    C = Control Code (Instruction) [4 bits]
    0 = Free bit [18 bits]
    D = Direction [2 bits] (See Pistion::DIRECTIONS for order)
    }
  end

  def self.make_color(direction)
    direction_bits = DIRECTIONS.index(direction).as(Int32)
    ((control_code << C24::CONTROL_CODE_BITSHIFT) + direction_bits).to_s 16
  end

  def self.make(direction)
    Direction.new(C24.new(make_color(direction).to_i 16))
  end

  def self.run(piston, direction)
    if direction != :random
      piston.change_direction(direction)
    else
      piston.change_direction Piston::DIRECTIONS.sample
    end
  end

  def run(piston)
    self.class.run(piston, DIRECTIONS[value[:value] % DIRECTIONS.size])
  end

  
  def info
    # Table with headings
    table = [] of Array(String)
    table << ["#{self.class}(#{self.class.control_code})\n------\nName", "#{value[:value].to_s(16)}\n------\nValue"]
    table << ["direction", "#{DIRECTIONS[value[:value] % DIRECTIONS.size]}"]
    table
  end

  def char : Char
    case DIRECTIONS[value[:value] % DIRECTIONS.size]
      when :up
        '\u2191'
      when :down
        '\u2193'
      when :left
        '\u2190'
      when :right
        '\u2192'
      when :turn_left
        '\u21b0'
      when :turn_right
        '\u21b1'
      when :reverse
        '\u21B6'
      when :random
        '\u2295'
      else
        '?'
    end
  end
end