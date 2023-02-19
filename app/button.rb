# Has the properties to be called as either border or label.
class Button
  attr_accessor :x, :y, :w, :h, :text

  # @x and @y values make it so that the passed in x and y
  # are the center of the border and label.
  def initialize x, y, text
    @text = text
    @w, @h = $gtk.calcstringbox @text
    @x = x - w / 2
    @y = y - h / 2
    @vertical_alignment_enum = 0
  end

  def border
    {
      x: @x - 5,
      y: @y - 5,
      w: @w + 10,
      h: @h + 10
    }
  end

  def label
    {
      x: @x,
      y: @y,
      text: @text,
      vertical_alignment_enum: @vertical_alignment_enum
    }
  end
end
