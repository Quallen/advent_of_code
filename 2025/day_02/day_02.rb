require 'pry-byebug'

class Product
  attr_reader :input

  def initialize
    @input = File.read('input.txt')
    @invalid_ids = []
  end

  def sum_invalid_ids
    id_ranges = input.split(',')
    id_ranges.each do |range|
      ids = range.split('-')
      range_start = ids.first.to_i
      range_end = ids.last.to_i
      (range_start..range_end).each do |id|
        @invalid_ids << id if invalid_id?(id.to_s)
      end
    end
    puts @invalid_ids.sum
  end

  def invalid_id?(id)
    return false if id.length == 1
    midpoint = id.length / 2
    id[0,midpoint] == id[midpoint,id.length-1]
  end
end

Product.new.sum_invalid_ids
