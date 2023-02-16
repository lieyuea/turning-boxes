$gtk.reset

require 'app/box.rb'
require 'app/game.rb'
require 'app/menu.rb'

def tick args
  args.state.gamestate ||= Menu.new args
  args.state.gamestate.args = args
  args.state.gamestate.tick

  args.outputs.debug << [
    {
      x: 0,
      y: 720,
      text: "mouse coord: #{args.inputs.mouse.x}, #{args.inputs.mouse.y}"
    }, {
      x: 0,
      y: 700,
      text: "framerate: #{args.gtk.current_framerate}"
    }, {
      x: 0,
      y: 680,
      text: "state: #{args.state.gamestate.class}"
    }
  ]
end
