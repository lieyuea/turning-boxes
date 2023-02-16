$gtk.reset seed: Time.now.to_i

=begin
Up to 9 boxes pointing different directions can spawn in a game.
The goal is to get every box pointed in the same direction.
Turning a box may turn other boxes. Some boxes cannot
be directly interacted with.
TODO: add basic controls
=end
class Game
  attr_gtk

  def initialize args
    @args      = args
    @boxsize   = 80
    @layout    = [-1, 0, 1].product [-1, 0, 1] # for iterating through @boxes with coords
    @boxes     = {} # gives boxes x and y coords
    @boxes_arr = [] # 1d array of all boxes for easier access
    @spaces    = [] # base position of the variable spaces where the boxes can be
    # loop through @layout and put a box in every position of @boxes and add the same box
    # to @boxes_arr, then add a position to @spaces based on the center of the grid.
    @layout.each do |x, y|
      @boxes[x]  ||= {}
      @boxes[x][y] = Box.new @boxsize
      @boxes_arr << @boxes[x][y]
      @spaces << {
        x: args.grid.w_half - @boxsize + @boxsize * 2 * x,
        y: args.grid.h_half - @boxsize + @boxsize * 2 * y
      }
    end

    @marker, @hover_marker = {
      w: @boxsize + 10,
      h: @boxsize + 10,
      r: 255,
      g: 0,
      b: 0
    }, {
      w: @boxsize + 10,
      h: @boxsize + 10,
      r: 255,
      g: 128,
      b: 0,
      a: 0
    }
    args.outputs.static_solids << [ @hover_marker, @marker ]
    args.outputs.static_sprites << @boxes_arr.each

    init_new_game
  end

  def tick; calc; draw; end

  def calc
    kb_controls
    ms_controls
  end

  def kb_controls
    key_pressed = keyboard.key_down.char
    return unless key_pressed

    case key_pressed
    when 'e', 'i'
      change_position :y, 1
    when 'f', 'l'
      change_position :x, 1
    when 'd', 'k'
      change_position :y, -1
    when 's', 'j'
      change_position :x, -1
    when 'w', 'u'
      turn_current_box 1
    when 'r', 'o'
      turn_current_box -1
    end
  end

  def change_position coord, dir
    @current_position[coord] += dir
    if @current_position[coord].abs > dir.abs
      @current_position[coord] = -dir
    end

    move_marker
  end

  def move_marker
    @marker << { x: current_box.x - 5, y: current_box.y - 5 }
    # @marker.x, @marker.y = current_box.x - 5, current_box.y - 5
  end

  def turn_current_box dir
    current_box.angle += 90 * dir
    if current_box.angle >= 360 || current_box.angle < 0
      current_box.angle += 360 * -dir
    end
  end

  def ms_controls
    hover_mouse_position = nil
    @layout.each do |x, y|
      if inputs.mouse.inside_rect? @boxes[x][y]
        hover_mouse_position = { x: x, y: y }
        break
      end
    end

    return @hover_marker.a = 0 unless hover_mouse_position

    @hover_marker << {
      x: @boxes[hover_mouse_position.x][hover_mouse_position.y].x - 5,
      y: @boxes[hover_mouse_position.x][hover_mouse_position.y].y - 5
    }
    @hover_marker.a = 255

    return unless inputs.mouse.click

    @current_position = hover_mouse_position
    move_marker

    if inputs.mouse.button_left
      turn_current_box 1
    elsif inputs.mouse.button_right
      turn_current_box -1
    end
  end

  def current_box
    @boxes[@current_position.x][@current_position.y]
  end

  # TODO: randomize how many boxes show up, which boxes show up, what angle they have
  def init_new_game
    @boxes_arr.size.times do |i|
      @boxes_arr[i].x = @spaces[i].x + rand(@boxsize + 1)
      @boxes_arr[i].y = @spaces[i].y + rand(@boxsize + 1)
      @boxes_arr[i].angle = 90 * rand(4)
    end

    @current_position = { x: 0, y: 0 }
    move_marker
  end

  def draw
    outputs.debug << [
      {
        x: 1280,
        y: 720,
        text: "Current box coord: #{@current_position}",
        alignment_enum: 2
      }, {
        x: 1280,
        y: 700,
        text: "Current box angle: #{current_box.angle}",
        alignment_enum: 2
      }
    ]
  end
end
