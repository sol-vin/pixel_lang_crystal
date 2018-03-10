require "../../../instruction.cr"

class Instruction
  def info
    table = [] of Array(String)
    table << ["#{self.class}(#{self.class.control_code})\n------\nName", "#{value[:value].to_s(16)}\n------\nValue"]
    table
  end
end