require 'active_support/all'
require 'pry-byebug'

class MetaMap
  attr_accessor :input, :length
  def initialize
    @input = File.read('problem_6_input.txt').lines.map(&:chomp)
    @length = input.length
    @base_map = Array.new(length){Array.new(length)}
    @guard_start = nil
    read_input
    @maps = []
    build_maps
  end

  def print_counts
    puts @maps.first.visited_count
    puts @maps.select{|map| map.cycle_found == true}.count
  end

  def read_input
    input.each_with_index do |line, row_index|
      line.each_char.with_index  do |character, column_index|
        @base_map[row_index][column_index] = Map::Location.new(letter: character, coords: [row_index, column_index] )
        @guard_start = @base_map[row_index][column_index] if @base_map[row_index][column_index].guard?
      end
    end
  end

  def build_maps
    @maps << Map.new(grid_data: @base_map, guard_start: @guard_start)
    @on_path = @maps.first.visited_locations
    @on_path.each do |location|
      next if location.obstacle? || location.guard?
      new_map = @base_map.deep_dup
      new_map[location.x][location.y] = Map::Location.new(letter: '#', coords: [location.x, location.y] )
      @maps << Map.new(grid_data: new_map, guard_start: @guard_start)
    end
  end
end

class Map
  attr_accessor :length, :cycle_found, :visited_locations
  def initialize(grid_data: , guard_start: )
    @grid = grid_data
    @guard_start = guard_start
    @length = @grid.length
    @visited_locations = []
    @cycle_found = false
    walk_map
  end

  def visited_count
    @visited_locations.count
  end

  def walk_map
    left_map = false
    already_visited, spinning = 0, 0
    directions = {up: [-1,0, :right], right: [0,1, :down], down: [1,0, :left], left: [0, -1, :up]}
    current_direction = :up
    current_position = @guard_start
    until left_map || @cycle_found
      move_relative = directions[current_direction]
      try_x = current_position.x + move_relative[0]
      try_y = current_position.y + move_relative[1]
      if try_x > length - 1 || try_y > length - 1 || try_x < 0 || try_y < 0
        left_map = true
        next
      elsif @grid[try_x][try_y].open?
        spinning = 0
        already_visited += 1 if @visited_locations.include?(@grid[try_x][try_y])
        @cycle_found = true if already_visited > 1000
        @visited_locations << @grid[try_x][try_y] unless @visited_locations.include?(@grid[try_x][try_y])
        current_position = @grid[try_x][try_y]
      elsif @grid[try_x][try_y].obstacle?
        spinning += 1
        @cycle_found = true if spinning > 10
        new_direction = directions[current_direction].last
        current_direction = new_direction
      end
    end
  end

  class Location
    attr_accessor :coordinates, :letter
    def initialize(letter: ,coords:)
      @letter = letter
      @coordinates = coords
    end

    def x
      coordinates.first
    end

    def y
      coordinates.last
    end

    def obstacle?
      letter == '#'
    end

    def guard?
      letter == '^'
    end

    def open?
      !obstacle?
    end
  end
end

search = MetaMap.new
search.print_counts
