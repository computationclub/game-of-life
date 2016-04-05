class Grid
  ALIVE = "\u2588"

  def initialize(cells = nil)
    @width = 80
    @height = 30
    @cells = cells || build_random_cells
  end

  def build_random_cells
    (@width * @height).times.map do |_|
      rand(2) == 1 ? ALIVE : ' '
    end
  end

  def tick
    new_cells =
      @height.times.flat_map do |y|
        @width.times.map do |x|
          next_cell(x,y)
        end
      end
    Grid.new(new_cells)
  end

  def next_cell(x,y)
    current_cell = cell_at(x,y)
    neighbours = neighbours_count(x,y)
    if current_cell == ALIVE
      if (2..3).include? neighbours
        ALIVE
      else
        ' '
      end
    else
      if neighbours == 3
        ALIVE
      else
        ' '
      end
    end
  end

  def neighbours_count(x,y)
    (x-1).upto(x+1).flat_map do |xi|
      (y-1).upto(y+1).map do |yi|
        next if xi == x && yi == y
        cell_at(xi,yi)
      end
    end.count { |c| c == ALIVE }
  end

  def cell_at(x,y)
    @cells[(y*@width)+x]
  end

  def to_s
    @height.times.map do |y|
      @width.times.map do |x|
        cell_at(x,y)
      end.join("")
    end.join("\n")
  end
end

g = Grid.new
loop do
  system('clear')
  puts g.to_s
  g = g.tick
  sleep(1)
end
