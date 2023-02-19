# Has the properties to be called as either border or label.
class Button
  attr_accessor :x, :y, :w, :h, :text

  # @x and @y values make it so that the passed in x and y
  # are the center of the border and label.
  def initialize x, y, text
    @text = text
    text_w, text_h = $gtk.calcstringbox @text
    @text_x = x - text_w / 2
    @text_y = y - text_h / 2
    @x = @text_x - 5
    @y = @text_y - 5
    @w = text_w + 10
    @h = text_h + 10
    @vertical_alignment_enum = 0
  end

  def border
    {
      x: @x,
      y: @y,
      w: @w,
      h: @h
    }
  end

  def label
    {
      x: @text_x,
      y: @text_y,
      text: @text,
      vertical_alignment_enum: @vertical_alignment_enum
    }
  end
end
