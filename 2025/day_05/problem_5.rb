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

  def fresh_count
    puts @fresh.count
  end
end

IngredientDatabase.new.fresh_count
