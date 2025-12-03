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
        @invalid_ids << id if repeating_pattern?(id.to_s)
      end
    end
    puts @invalid_ids.sum
  end

  def repeating_pattern?(id)
    patterns = id.scan(/(.+?)(?=\1+$|$)/)

    repeated_patterns = patterns.flatten.select{ |pattern| id.scan(Regexp.new(Regexp.escape(pattern))).size > 1 }

    repeated_patterns.any?
  end
end

Product.new.sum_invalid_ids
