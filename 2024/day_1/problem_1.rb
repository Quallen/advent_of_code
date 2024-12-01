require 'active_support/all'
require 'pry-byebug'

class Locations
  attr_accessor :input, :left_list, :right_list, :length

  def initialize
    @input = File.read('problem_1_input.txt').lines.map(&:chomp)
    @left_list = []
    @right_list = []
    initialize_lists
    @length = left_list.count
  end

  def initialize_lists
    input.each do |line|
      values = line.split(" ")
      left_list << values[0]
      right_list << values[1]
    end
  end

  def calculate_distances
    sorted_left = left_list.sort
    sorted_right = right_list.sort
    distances = []
    length.times do |index|
      distances << (sorted_left[index].to_i - sorted_right[index].to_i).abs
    end
    puts distances.sum
  end
end

locations = Locations.new
locations.calculate_distances
