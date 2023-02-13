$gtk.reset

require 'app/game.rb'
require 'app/menu.rb'

def tick args
  args.state.gamestate ||= Menu.new args
  args.state.gamestate.tick

  args.outputs.debug << [
    # mouse coord
    { x: 0,
      y: 720,
      text: "mouse coord: #{args.inputs.mouse.x}, #{args.inputs.mouse.y}" },
    # framerate
    { x: 0,
      y: 700,
      text: "framerate: #{args.gtk.current_framerate}" }
  ]
end
