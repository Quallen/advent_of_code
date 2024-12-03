require 'active_support/all'
require 'pry-byebug'

class Computer
  attr_accessor :input, :regex, :result, :instructions

  def initialize
    @input = File.read('problem_3_input.txt')
    @regex = /mul\(\d+,\d+\)/

    @instructions = input.scan(regex)

    @result = 0
  end

  def execute
    instructions.each do |instruction|
      split_string = instruction.split(",")
      operands = instruction.split(",").map{|op| op.tr('^0-9', '').to_i}
      @result += (operands[0] * operands[1])
    end
  end

  def print_results
    puts @result
  end
end

computer = Computer.new
computer.execute
computer.print_results
