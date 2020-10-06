# Renders an ecr file with the layout around it
macro render_layout(filename)
  render "./src/web_app/views/#{{{filename}}}.ecr", "./src/web_app/views/layout.ecr"
end

# Renders just an ecr file
macro render_file(filename)
  render "./src/web_app/views/#{{{filename}}}.ecr"
end