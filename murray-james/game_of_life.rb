class Cell
  def self.random(*args)
    rand(2) > 0 ? LivingCell.new(*args) : DeadCell.new(*args)
  end

  attr_accessor :nw, :n, :ne, :e, :se, :s, :sw, :w

  def initialize(nw: nil, n: nil, ne: nil, e: nil, se: nil, s: nil, sw: nil, w: nil)
    self.nw = nw
    self.n  = n
    self.ne = ne
    self.e  = e
    self.se = se
    self.s  = s
    self.sw = sw
    self.w  = w
  end

  def inspect
    object_id
  end

  def update_neighbours(nw: nil, n: nil, ne: nil, e: nil, se: nil, s: nil, sw: nil, w: nil)
    self.nw = nw if nw
    self.n  = n  if n
    self.ne = ne if ne
    self.e  = e  if e
    self.se = se if se
    self.s  = s  if s
    self.sw = sw if sw
    self.w  = w  if w
  end

  def generate_neighbours
    self.nw ||= Cell.random
    self.n  ||= Cell.random
    self.ne ||= Cell.random
    self.e  ||= Cell.random
    self.se ||= Cell.random
    self.s  ||= Cell.random
    self.sw ||= Cell.random
    self.w  ||= Cell.random

    nw.update_neighbours(e: n, s: w, se: self)
    n.update_neighbours(w: nw, sw: w, s: self, se: e, e: ne)
    ne.update_neighbours(w: n, sw: self, s: w)
    w.update_neighbours(n: nw, ne: n, e: self, se: s, s: sw)
    e.update_neighbours(nw: n, n: ne, s: se, sw: s, w: self)
    se.update_neighbours(nw: self, n: e, w: s)
    s.update_neighbours(nw: w, n: self, ne: e, e: se, w: sw)
    sw.update_neighbours(n: w, ne: self, e: s)
  end

  def each_neighbour
    yield nw, :nw
    yield n, :n
    yield ne, :ne
    yield w, :w
    yield e, :e
    yield sw, :sw
    yield s, :s
    yield se, :se
  end
end

class LivingCell < Cell
  def to_s
    "#"
  end
end

class DeadCell < Cell
  def to_s
    "."
  end
end

class World
  attr_reader :start_cell

  def initialize(width)
    @start_cell = Cell.random
    build_out(@start_cell, width)
  end

  def build_out(cell, limit)
    return if limit == 0
    cell.generate_neighbours
    cell.each_neighbour do |neighbour, direction|
      build_out(neighbour, limit - 1)
    end
  end

  def display
    start_of_row = north_west_corner(@start_cell)
    cell = start_of_row
    until start_of_row.nil?
      until cell.nil?
        print cell.to_s
        cell = cell.e
      end
      puts
      start_of_row = start_of_row.s
      cell = start_of_row
    end
  end

  def north_west_corner(start_cell)
    cell = start_cell
    until cell.w.nil?
      cell = cell.w
    end
    until cell.n.nil?
      cell = cell.n
    end
    cell
  end
end

world = World.new(2)
world.display
