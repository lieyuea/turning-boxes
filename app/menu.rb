$gtk.reset

class Menu
  attr_gtk

  def initialize args
    @args = args
    center_x = args.grid.w_half
    center_y = args.grid.h_half
    @play_button = { x: center_x - 50, y: center_y - 25, w: 100, h: 50 }
    @play_button_text = {
      x: center_x, y: center_y, text: "(P)lay",
      alignment_enum: 1, vertical_alignment_enum: 1
    }

    outputs.static_borders << @play_button
    args.outputs.static_labels << @play_button_text
  end

  def tick; calc; draw; end

  def calc
    return unless inputs.keyboard.key_down.p ||
                  inputs.mouse.click && inputs.mouse.inside_rect?(@play_button)

    outputs.static_borders.clear
    outputs.static_labels.clear
    state.gamestate = Game.new @args
  end

  def draw; end
end
