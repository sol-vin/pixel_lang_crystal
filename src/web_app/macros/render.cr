# Renders an ecr file with the layout around it
macro render_layout(filename)
  render "./src/views/#{{{filename}}}.ecr", "./src/views/layout.ecr"
end

# Renders just an ecr file
macro render_file(filename)
  render "./src/views/#{{{filename}}}.ecr"
end