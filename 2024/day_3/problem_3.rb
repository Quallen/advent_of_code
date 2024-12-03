require 'active_support/all'
require 'pry-byebug'

class Computer
  attr_accessor :input, :regex, :result, :enabled_result, :disabled_input, :instructions, :enabled_instructions

  def initialize
    @input = File.read('problem_3_input.txt')
    @regex = /mul\(\d+,\d+\)/
    @disabled_input = input.dup
    scrub_disabled_instructions

    @instructions = input.scan(regex)
    @enabled_instructions = disabled_input.scan(regex)

    @result, @enabled_result = 0,0
  end

  def scrub_disabled_instructions
    disable_positions = input.enum_for(:scan, /don't\(\)/).map { Regexp.last_match.begin(0) }
    disable_positions.each do |disable_position|
      enable_position = input.index("do()", disable_position)
      range = disable_position..enable_position+3
      range.each do |position|
        disabled_input[position] = 'x'
      end
    end
    File.write('disabled_input_visualization.txt', disabled_input)
  end

  def execute
    [ ['instructions','result'], ['enabled_instructions', 'enabled_result'] ].each do |instruction_stream, store_result|
      send(instruction_stream).each do |instruction|
        split_string = instruction.split(",")
        operands = instruction.split(",").map{|op| op.tr('^0-9', '').to_i}
        current_sum = send(store_result)
        instance_variable_set("@#{store_result}", current_sum + (operands[0] * operands[1]) )
      end
    end
  end

  def print_results
    puts @result
    puts @enabled_result
  end
end

computer = Computer.new
computer.execute
computer.print_results
