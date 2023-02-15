class Game
  attr_gtk

  def initialize args
    @args = args
  end

  def tick; calc; draw; end

  def calc; end

  def draw; end
end
