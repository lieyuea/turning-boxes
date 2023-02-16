$gtk.reset seed: Time.now.to_i

=begin
Up to 9 boxes pointing different directions can spawn in a game.
The goal is to get every box pointed in the same diriction.
Turning a box may turn other boxes. Some boxes cannot
be directly interacted with.
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
        x: args.grid.w_half - @boxsize + (@boxsize * 2 * x),
        y: args.grid.h_half - @boxsize + (@boxsize * 2 * y)
      }
    end

    @marker = {
      w: @boxsize + 10,
      h: @boxsize + 10,
      r: 255,
      g: 0,
      b: 0
    }

    new_game
  end

  def tick; calc; draw; end

  def calc; end

  # TODO: randomize how many boxes show up, which boxes show up, what angle they have
  def new_game
    @boxes_arr.size.times do |i|
      @boxes_arr[i].x = @spaces[i].x + rand(@boxsize + 1)
      @boxes_arr[i].y = @spaces[i].y + rand(@boxsize + 1)
      @boxes_arr[i].angle = 90 * rand(4)
    end

    @current_box = @boxes_arr[0]

    @marker << { x: @current_box.x - 5, y: @current_box.y - 5 }

    static_draw
  end

  def static_draw
    outputs.static_solids << @marker
    outputs.static_sprites << @boxes_arr.each { |box| box }
  end

  def draw; end
end
