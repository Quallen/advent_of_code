require 'active_support/all'
require 'pry-byebug'

class Reactor

  attr_accessor :input, :reports

  def initialize
    @input = File.read('problem_2_input.txt').lines.map(&:chomp)
    @reports = []
    input.each do |line|
      reports << Report.new(data: line.split(" ").map(&:to_i))
    end
  end

  def check_reports
    puts reports.count{|report| report.safe? }
  end

  class Report
    attr_accessor :data, :values

    def initialize(data:)
      @values = data
    end

    def safe?
      (all_increasing? || all_decreasing?) && within_range?
    end

    def all_increasing?
      values.sort == values
    end

    def all_decreasing?
      values.sort.reverse == values
    end

    def within_range?
      values.each_with_index do |value, index|
        return true if index == values.count - 1
        return false unless pair_in_range?(left: value , right: values[index + 1])
      end
    end

    def pair_in_range?(left: , right:)
      (left != right) && ( (right - left).abs <= 3 )
    end

  end
end

Reactor.new.check_reports
