require './../instruction'
require './../piston'

class Fork < Instruction
  DIRECTIONS = {
      urd: {
          up:  -> p { p.parent.fork(p, :right) },
          left: -> p {
            p.parent.fork(p, :left)
            p.turn_right
          },
          down: -> p { p.parent.fork(p, :left) },
          right: -> p { p.reverse }
      },

      dlr: {
          up:  -> p {
            p.parent.fork(p, :left)
            p.turn_right
          },
          left: -> p { p.parent.fork(p, :left) },
          down: -> p { p.reverse },
          right: -> p { p.parent.fork(p, :right) }
      },

      uld: {
          up:  -> p { p.parent.fork(p, :left) },
          left: -> p { p.reverse },
          down: -> p { p.parent.fork(p, :right) },
          right: -> p {
            p.parent.fork(p, :left)
            p.turn_right
          }
      },

      ulr: {
          up:  -> p { p.reverse },
          left: -> p { p.parent.fork(p, :right) },
          down: -> p {
            p.parent.fork(p, :left)
            p.turn_right
          },
          right: -> p { p.parent.fork(p, :left) }
      },

      ulrd: {
          up: -> p {
            p.parent.fork(p, :right)
            p.parent.fork(p, :left)
          },
          left: -> p {
            p.parent.fork(p, :right)
            p.parent.fork(p, :left)
          },
          down: -> p {
            p.parent.fork(p, :right)
            p.parent.fork(p, :left)
          },
          right: -> p {
            p.parent.fork(p, :right)
            p.parent.fork(p, :left)
          },
      },

      r_urd: {
          up:  -> p {
            p.parent.fork(p, :right)
            p.parent.fork(p, :reverse)
          },
          left: -> p {
            p.parent.fork(p, :left)
            p.turn_right
            p.parent.fork(p, :reverse)
          },
          down: -> p {
            p.parent.fork(p, :left)
            p.parent.fork(p, :reverse)
          },
          right: -> p { p.reverse }
      },

      r_dlr: {
          up:  -> p {
            p.parent.fork(p, :left)
            p.turn_right
            p.parent.fork(p, :reverse)
          },
          left: -> p {
            p.parent.fork(p, :left)
            p.parent.fork(p, :reverse)
          },
          down: -> p { p.reverse },
          right: -> p {
            p.parent.fork(p, :right)
            p.parent.fork(p, :reverse)
          }
      },

      r_uld: {
          up:  -> p {
            p.parent.fork(p, :left)
            p.parent.fork(p, :reverse)
          },
          left: -> p { p.reverse },
          down: -> p {
            p.parent.fork(p, :right)
            p.parent.fork(p, :reverse)
          },
          right: -> p {
            p.parent.fork(p, :left)
            p.turn_right
            p.parent.fork(p, :reverse)
          }
      },

      r_ulr: {
          up:  -> p { p.reverse },
          left: -> p {
            p.parent.fork(p, :right)
            p.parent.fork(p, :reverse)
          },
          down: -> p {
          p.parent.fork(p, :left)
          p.turn_right
          p.parent.fork(p, :reverse)
          },
          right: -> p {
            p.parent.fork(p, :left)
            p.parent.fork(p, :reverse)
          }
      },

      r_ulrd: {
          up: -> p {
            p.parent.fork(p, :right)
            p.parent.fork(p, :left)
            p.parent.fork(p, :reverse)
          },
          left: -> p {
            p.parent.fork(p, :right)
            p.parent.fork(p, :left)
            p.parent.fork(p, :reverse)
          },
          down: -> p {
            p.parent.fork(p, :right)
            p.parent.fork(p, :left)
            p.parent.fork(p, :reverse)
          },
          right: -> p {
            p.parent.fork(p, :right)
            p.parent.fork(p, :left)
            p.parent.fork(p, :reverse)
          },
      },
  }

  def self.control_code
    0x4
  end

  def self.reference_card
    puts %q{
    Fork Instruction
    Forks a piston into multiple readers with different directions
    0bCCCC00000000000000000TTT
    C = Control Code (Instruction) [4 bits]
    0 = Free bit [17 bits]
    T = Type [3 bits] (See Fork::TYPES for order)
    }
  end
  #TODO: FIX THIS!
  def self.make_color(fork_type)
    ((control_code << CONTROL_CODE_BITSHIFT) + fork_type).to_s 16
  end

  def self.run(piston, fork_type)
    DIRECTIONS[fork_type][piston.direction][piston]
  end

  def initialize(value : UInt32)
    super value
    @value.add_mask(:fork_type, VALUE_BITS, VALUE_BITSHIFT)
  end

  def run(piston)
    self.class.run(piston, DIRECTIONS.keys[value[:fork_type]])
  end
end