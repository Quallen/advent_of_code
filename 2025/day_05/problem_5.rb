require 'pry-byebug'

class IngredientDatabase
  attr_reader :input
  def initialize
    @input = File.read('input.txt').lines.map(&:chomp)
    @fresh_id_ranges = []
    @ingredients = []
    @fresh = []
    parse_input
    bin_ingredients
  end

  def parse_input
    input.each do |line|
      case line
      when /-/
        data = line.split('-')
        @fresh_id_ranges << (data.first.to_i..data.last.to_i)
      when /\d/
        @ingredients << line.to_i
      end
    end
  end

  def bin_ingredients
    @ingredients.each do |id|
      @fresh_id_ranges.each do |id_range|
        if id_range.include?(id.to_i)
          @fresh << id
          break
        end
      end
    end
  end

  def fresh_counts
    puts @fresh.count
    puts total_fresh_ids
  end

  def total_fresh_ids
    sorted_ranges = @fresh_id_ranges.dup
    loop do
      overlap_count = 0
      sorted_ranges.reject!{|range| range.size == 0}
      sorted_ranges.sort_by!(&:end).each_with_index do |range, index|
        next if index+1 == sorted_ranges.count
        next unless range.overlap?(next_range = sorted_ranges[index + 1])

        sorted_ranges[index] = (range.begin...next_range.begin) if range.end >= next_range.begin

        overlap_count += 1
      end
      break if overlap_count.zero?
    end

    sorted_ranges.sum{|id_range| id_range.size}
  end
end

IngredientDatabase.new.fresh_counts
