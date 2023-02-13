class Game
  attr_gtk

  def initialize args
    @args = args
  end

  def tick
    inputs; update; render
  end

  def inputs
  end

  def update
  end

  def render
  end
end
