require 'pry-byebug'

class Search
  attr_accessor :input, :length

  def initialize
    @input = File.read('problem_4_input.txt').lines.map(&:chomp)
    @length = 140
    @grid = Array.new(length){Array.new(length)}
    init_grid
    @possible_xmas_starts, @possible_x_mas_starts = [], []
    get_start_locations
    @xmas_count, @x_mas_count = 0, 0
  end

  def init_grid
    input.each_with_index do |line, row_index|
      line.each_char.with_index  do |character, column_index|
        @grid[row_index][column_index] = Location.new(letter: character, coords: [row_index, column_index] )
      end
    end
  end

  def get_start_locations
    input.each_with_index do |line, row_index|
      line.each_char.with_index  do |character, column_index|
        @possible_xmas_starts << @grid[row_index][column_index] if @grid[row_index][column_index].word_start?
        @possible_x_mas_starts << @grid[row_index][column_index] if @grid[row_index][column_index].a?
      end
    end
  end

  def get_xmas_count
    @possible_xmas_starts.each do |location|
      %w(right left down up diagonal_right_down diagonal_right_up diagonal_left_down diagonal_left_up).each do |direction|
        send("scan_#{direction}", location)
      end
    end
    puts @xmas_count
  end

  def get_x_mas_count
    @possible_x_mas_starts.each do |location|
      scan_x_mas(location)
    end
    puts @x_mas_count
  end

  def scan_right(point)
    return if point.x + 3 > length - 1
    @xmas_count += 1 if @grid[point.x+1][point.y].m? && @grid[point.x+2][point.y].a? && @grid[point.x+3][point.y].s?
  end

  def scan_left(point)
    return if point.x - 3 < 0
    @xmas_count += 1 if @grid[point.x-1][point.y].m? && @grid[point.x-2][point.y].a? && @grid[point.x-3][point.y].s?
  end

  def scan_down(point)
    return if point.y + 3 > length - 1
    @xmas_count += 1 if @grid[point.x][point.y+1].m? && @grid[point.x][point.y+2].a? && @grid[point.x][point.y+3].s?
  end

  def scan_up(point)
    return if point.y - 3 < 0
    @xmas_count += 1 if @grid[point.x][point.y-1].m? && @grid[point.x][point.y-2].a? && @grid[point.x][point.y-3].s?
  end

  def scan_diagonal_right_down(point)
    return if point.x + 3 > length - 1 || point.y + 3 > length - 1
    @xmas_count += 1 if @grid[point.x+1][point.y+1].m? && @grid[point.x+2][point.y+2].a? && @grid[point.x+3][point.y+3].s?
  end

  def scan_diagonal_right_up(point)
    return if point.x + 3 > length - 1 || point.y - 3 < 0
    @xmas_count += 1 if @grid[point.x+1][point.y-1].m? && @grid[point.x+2][point.y-2].a? && @grid[point.x+3][point.y-3].s?
  end

  def scan_diagonal_left_down(point)
    return if point.x - 3 < 0 || point.y + 3 > length - 1
    @xmas_count += 1 if @grid[point.x-1][point.y+1].m? && @grid[point.x-2][point.y+2].a? && @grid[point.x-3][point.y+3].s?
  end

  def scan_diagonal_left_up(point)
    return if point.x - 3 < 0 || point.y - 3 < 0
    @xmas_count += 1 if @grid[point.x-1][point.y-1].m? && @grid[point.x-2][point.y-2].a? && @grid[point.x-3][point.y-3].s?
  end

  def scan_x_mas(point)
    return if point.x - 1 < 0 || point.y - 1 < 0 || point.x + 1 > length - 1 || point.y + 1 > length - 1
    @x_mas_count += 1 if @grid[point.x-1][point.y-1].m? && @grid[point.x+1][point.y-1].s? && @grid[point.x-1][point.y+1].m? && @grid[point.x+1][point.y+1].s?
    @x_mas_count += 1 if @grid[point.x-1][point.y-1].m? && @grid[point.x+1][point.y-1].m? && @grid[point.x-1][point.y+1].s? && @grid[point.x+1][point.y+1].s?
    @x_mas_count += 1 if @grid[point.x-1][point.y-1].s? && @grid[point.x+1][point.y-1].m? && @grid[point.x-1][point.y+1].s? && @grid[point.x+1][point.y+1].m?
    @x_mas_count += 1 if @grid[point.x-1][point.y-1].s? && @grid[point.x+1][point.y-1].s? && @grid[point.x-1][point.y+1].m? && @grid[point.x+1][point.y+1].m?
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

    def word_start?
      letter == 'X'
    end

    def m?
      letter == 'M'
    end

    def a?
      letter == 'A'
    end

    def s?
      letter == 'S'
    end

  end
end
search = Search.new
search.get_xmas_count
search.get_x_mas_count
