class Box
  attr_sprite
  attr_accessor :links

  def initialize size
    @w = @h = size
    @path = 'sprites/square/white.png'
    @links = []
  end

  def turn dir
    @angle += 90 * dir
    if @angle >= 360 || @angle < 0
      @angle += 360 * -dir
    end

    # Cannot do box.turn because it will also turn the boxes linked to those boxes and so on.
    @links.each do |box|
      box.angle += 90 * dir
      if box.angle >= 360 || box.angle < 0
        box.angle += 360 * -dir
      end
    end
  end
end
