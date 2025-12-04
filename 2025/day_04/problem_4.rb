require 'pry-byebug'

class Map
  ADJACENT_LOCATIONS = [ [-1, -1], [-1, 0], [-1, 1], [ 0, -1], [ 0, 1], [ 1, -1], [ 1, 0], [ 1, 1] ]
  attr_reader :input, :length, :map

  def initialize
    @input = File.read('input.txt').lines.map(&:chomp)
    @length = input.length
    @map = Array.new(length){Array.new(length)}
    init_map
    pad_map
  end

  def init_map
    input.each_with_index do |line, row_index|
      line.each_char.with_index do |character, column_index|
        @map[row_index][column_index] = character == '@' ? 1 : 0
      end
    end
  end

  def pad_map
    @map.insert(0, Array.new(length, 0))
    @map.append(Array.new(length, 0))
    @map.each_with_index do |row,index|
      row.insert(0, 0)
      row.append(0)
    end
  end

  def find_accessible
    accessible_count = 0

    map.each_with_index do |row, row_index|
      row.each_with_index do |value, column_index|
        accessible_count += 1 if value.positive? && adjacency_count(x: row_index, y: column_index) < 4
      end
    end
    puts accessible_count
  end

  def adjacency_count(x:,y:)
    ADJACENT_LOCATIONS.sum do |x_offset, y_offset|
      map[x + x_offset][y + y_offset]
    end
  end
end

Map.new.find_accessible
