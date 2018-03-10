require "../../../meta_instruction"

class MetaInstruction
  def info
    # Table with headings
    table = super
    table << ["meta_code", value[:meta_code].to_s]
    table
  end
end