$gtk.reset

class Menu
  attr_gtk

  def initialize args
    @args = args

    @play_button = Button.new args.grid.w_half, args.grid.h_half, "(P)lay"
    args.outputs.static_borders << @play_button.border
    args.outputs.static_labels << @play_button.label
  end

  def tick
    return unless inputs.keyboard.key_down.p ||
                  inputs.mouse.click && inputs.mouse.inside_rect?(@play_button)

    outputs.static_borders.clear
    outputs.static_labels.clear
    state.gamestate = Game.new @args
  end
end
