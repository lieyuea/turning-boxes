$scene = Game.new $args

def tick args
  $scene.tick args

  args.outputs.debug << [
    {
      x: 0,
      y: 720,
      text: "mouse coord: #{args.inputs.mouse.x}, #{args.inputs.mouse.y}"
    }, {
      x: 0,
      y: 700,
      text: "framerate: #{args.gtk.current_framerate}"
    }
  ]
end
