$gtk.reset

class Menu
  attr_gtk

  def initialize args
    @args = args
    @play_button = {
      x: args.grid.w_half - 50,
      y: args.grid.h_half - 25,
      w: 100,
      h: 50
    }
    @play_button_text = {
      x: args.grid.w_half,
      y: args.grid.h_half,
      text: "(P)lay",
      alignment_enum: 1,
      vertical_alignment_enum: 1
    }

    outputs.static_borders << @play_button
    args.outputs.static_labels << @play_button_text
  end

  def tick
    return unless inputs.keyboard.key_down.p ||
                  inputs.mouse.click && inputs.mouse.inside_rect?(@play_button)

    outputs.static_borders.clear
    outputs.static_labels.clear
    state.gamestate = Game.new @args
  end
end
