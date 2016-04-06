class Game
  def initialize(cells = nil)
    @height = 16
    @width  = 16
    @cells = cells || build_new_cells
  end

  def build_new_cells
    row = " " * @width + "\n"
    cells = ""
    cells << row
    cells << "  *  " + (" " * 11) + "\n"
    cells << "   * " + (" " * 11) + "\n"
    cells << " *** " + (" " * 11) + "\n"
    cells << "     " + (" " * 11) + "\n"
    cells << (row * 12)
  end

  def tick
    new_cells = ""

    @cells.each_char.with_index do |char, index|
      row = index / 17
      col = index % 17
      new_cell = next_cell(char, row, col)
      new_cells << new_cell
    end

    Game.new(new_cells)
  end

  #if cell is alive, look at all its neighbours, if they are two/three the cell lives
  #if cell is dead, look at its neighbours if three are alive, then revive cell
  def next_cell(char, row, col)
    neighbour_count = neighbours_count(row, col)

    #if char == "*" && (2..3).include?(neighbour_count)
    #  return char
    #elsif char == " " && neighbour_count == 3
    #    "*"
    #elsif char == "\n"
    #  char
    #else
    #  " "
    #end

    if char == "*"
      if (2..3).include? neighbour_count
        char
      else
        " "
      end
    else
      if neighbour_count == 3
        "*"
      else
        char
      end
    end
  end

  def neighbours_count(row, col)
    alive = 0
    alive += 1 if "*" == cell_at(row-1, col-1)
    alive += 1 if "*" == cell_at(row-1, col+1)
    alive += 1 if "*" == cell_at(row-1, col)
    alive += 1 if "*" == cell_at(row, col-1)
    alive += 1 if "*" == cell_at(row, col+1)
    alive += 1 if "*" == cell_at(row+1, col)
    alive += 1 if "*" == cell_at(row+1, col-1)
    alive += 1 if "*" == cell_at(row+1, col+1)
    alive
  end

  def cell_at(row, col)
    @cells[(row * (@width + 1)) + col]
  end

  def to_s
    @cells
  end
end

g = Game.new

loop do
  system('clear')
  puts g.to_s
  g = g.tick
  sleep(1)
end

