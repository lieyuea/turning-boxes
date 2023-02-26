$gtk.reset seed: Time.now.to_i

=begin
9 boxes pointing different directions can spawn in a game.
The goal is to get every box pointed in the same direction.
Turning a box may turn other boxes. Some boxes cannot be directly
interacted with.
TODO: Disable some boxes from interactability
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

    @marker = {
      w: @boxsize + 10,
      h: @boxsize + 10,
      r: 255,
      g: 0,
      b: 0,
    }
    args.outputs.static_solids  << @marker
    args.outputs.static_sprites << @boxes_arr.each

    @new_game_button = Button.new args.grid.left + 100, args.grid.bottom + 40, "(N)ew game"
    args.outputs.static_borders << @new_game_button.border
    args.outputs.static_labels  << @new_game_button.label

    default_controls
    init_new_game
  end

  def default_controls
    state.control_scheme = {
      up:         ['e', 'i'],
      down:       ['d', 'k'],
      left:       ['s', 'j'],
      right:      ['f', 'l'],
      turn_left:  ['w', 'u'],
      turn_right: ['r', 'o'],
      new_game:   ['n'],
    }
  end

  def tick; calc; debug; end

  def calc
    key_pressed = keyboard.key_down.char
    return unless key_pressed

    controls = state.control_scheme

    case key_pressed
    when *controls[:new_game]
      return init_new_game
    end

    return if @game_won

    case key_pressed
      when *controls[:up]         then move_position :y,  1
      when *controls[:right]      then move_position :x,  1
      when *controls[:down]       then move_position :y, -1
      when *controls[:left]       then move_position :x, -1
      when *controls[:turn_left]  then current_box.turn   1; check_win
      when *controls[:turn_right] then current_box.turn  -1; check_win
    end
  end

  def move_position coord, dir
    @current_position[coord] += dir
    if @current_position[coord].abs > dir.abs
      @current_position[coord] = -dir
    end

    move_marker
  end

  def move_marker
    @marker.x, @marker.y = current_box.x - 5, current_box.y - 5
  end

  def current_box
    @boxes[@current_position.x][@current_position.y]
  end

  def check_win
    angle = @boxes_arr[0].angle
    @boxes_arr.each do |box|
      return unless box.angle == angle
    end

    @game_won = true
  end

  def init_new_game
    @game_won = false

    @layout.each do |x, y|
      @boxes[x][y].x = grid.w_half - @boxsize + @boxsize * 2 * x + rand(@boxsize + 1)
      @boxes[x][y].y = grid.h_half - @boxsize + @boxsize * 2 * y + rand(@boxsize + 1)
      @boxes[x][y].angle = 90 * rand(4)
      @boxes[x][y].links.clear
      rand(3).times do |linkbox|
        linkbox = @boxes_arr[rand(@boxes_arr.size)]
        unless linkbox == @boxes[x][y] || @boxes[x][y].links.include?(linkbox)
          @boxes[x][y].links << linkbox
        end
      end
    end

    @current_position = { x: 0, y: 0 }
    move_marker
  end

  def debug
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
      }, {
        x: 1280,
        y: 680,
        text: "Game won: #{@game_won}",
        alignment_enum: 2
      }
    ]
  end
end
