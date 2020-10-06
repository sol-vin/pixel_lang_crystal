module Engines
  @@engines = {} of String => AutoEngine
  def self.[](key)
    @@engines[key]
  end

  def self.[]=(key, value)
    @@engines[key] = value
  end

  def self.keys
    @@engines.keys
  end
end