$gtk.reset seed: Time.now.to_i

=begin
Up to 9 boxes pointing different directions can spawn in a game.
The goal is to get every box pointed in the same direction.
Turning a box may turn other boxes. Some boxes cannot be directly
interacted with.
TODO: box connections and start new game
=end
class Game
  attr_gtk

  def initialize args
    @args      = args
    @boxsize   = 80
    @layout    = [-1, 0, 1].product [-1, 0, 1] # for iterating through @boxes with coords
    @boxes     = {} # boxes with x and y coords
    @boxes_arr = [] # 1d array of @boxes for easier access
    # loop through @layout and put a box in every position of @boxes and add the same box
    # to @boxes_arr
    @layout.each do |x, y|
      @boxes[x]  ||= {}
      @boxes[x][y] = Box.new @boxsize
      @boxes_arr << @boxes[x][y]
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
      r: 0,
      g: 255,
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
      kb_change_position :y, 1
    when 'f', 'l'
      kb_change_position :x, 1
    when 'd', 'k'
      kb_change_position :y, -1
    when 's', 'j'
      kb_change_position :x, -1
    when 'w', 'u'
      current_box.turn 1
    when 'r', 'o'
      current_box.turn -1
    end
  end

  def kb_change_position coord, dir
    @current_position[coord] += dir
    if @current_position[coord].abs > dir.abs
      @current_position[coord] = -dir
    end

    move_marker
  end

  def ms_controls
    mouse_position = find_mouse_in_box

    return @hover_marker.a = 0 unless mouse_position

    set_hover_marker mouse_position
    ms_change_position mouse_position if inputs.mouse.click
  end

  def find_mouse_in_box
    @layout.each do |x, y|
      if inputs.mouse.inside_rect? @boxes[x][y]
        return { x: x, y: y }
      end
    end

    return nil
  end

  def set_hover_marker mouse_position
    @hover_marker << {
      x: @boxes[mouse_position.x][mouse_position.y].x - 5,
      y: @boxes[mouse_position.x][mouse_position.y].y - 5
    }
    @hover_marker.a = 255
  end

  def ms_change_position mouse_position
    dir = 0
    case inputs.mouse.button_bits
    when 1
      dir = 1
    when 4
      dir = -1
    else
      return
    end

    @current_position = mouse_position
    move_marker
    current_box.turn dir
  end

  def move_marker
    @marker << { x: current_box.x - 5, y: current_box.y - 5 }
    # @marker.x, @marker.y = current_box.x - 5, current_box.y - 5
  end

  def current_box
    @boxes[@current_position.x][@current_position.y]
  end

  # TODO: randomize how many boxes show up, which boxes show up, what angle they have
  def init_new_game
    @layout.each do |x, y|
      @boxes[x][y].x = grid.w_half - @boxsize + @boxsize * 2 * x + rand(@boxsize + 1)
      @boxes[x][y].y = grid.h_half - @boxsize + @boxsize * 2 * y + rand(@boxsize + 1)
      @boxes[x][y].angle = 90 * rand(4)
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
