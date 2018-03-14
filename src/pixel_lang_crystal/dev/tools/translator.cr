# Displays the PNG in certain formats
#   For example, as hex plain text, bitmap
#   Goal: write pixel_lang to crystal opcode translation
#        - ex: 0x100234 would be translated to Start.make(0x00234)
#        - ex: 0x7671b8 would be Conditional.make(:left, :right, :i, 0, :==, :i, 0)
#   Goal: Translate all programs into this format, have crystal generate the examples dynamically.