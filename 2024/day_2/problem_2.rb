require 'active_support/all'
require 'pry-byebug'

class Reactor

  attr_accessor :input, :reports, :meta_reports

  def initialize
    @input = File.read('problem_2_input.txt').lines.map(&:chomp)
    @reports, @meta_reports = [], []
    input.each do |line|
      values = line.split(" ").map(&:to_i)
      reports << Report.new(data: values)
      meta_reports << MetaReport.new(data: values)
    end
  end

  def check_reports
    puts reports.count{|report| report.safe? }
    puts meta_reports.count{|report| report.safe? }
  end

  class MetaReport
    attr_accessor :data, :values, :reports

    def initialize(data:)
      @values = data
      @reports = []
      reports << Report.new(data: data)
      values.count.times do |sub_report|
        sub_array = values.dup
        sub_array.delete_at(sub_report)
        reports << Report.new(data: sub_array)
      end
    end

    def safe?
      reports.any?{ |report| report.safe? }
    end
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
