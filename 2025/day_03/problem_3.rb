require 'pry-byebug'

class JoltageFinder
  attr_reader :input

  def initialize
    @input = File.read('input.txt').lines.map(&:chomp)
    @battery_banks = []
    initialize_battery_banks
  end

  def initialize_battery_banks
    input.map{|line| @battery_banks << BatteryBank.new(data: line)}
  end

  def total_joltage
    puts @battery_banks.sum{ |battery| battery.two_battery_max_joltage }
    puts @battery_banks.sum{ |battery| battery.twelve_battery_max_joltage }
  end
end

class BatteryBank
  attr_reader :batteries

  def initialize(data:)
    @batteries = data
  end

  def two_battery_max_joltage
    max = 0
    batteries.each_char.with_index do |battery, position|
      sub_string = batteries[position+1..-1]
      sub_string.each_char.with_index do |sub_battery, index|
        joltage = (battery + sub_battery).to_i
        max = joltage if joltage > max
      end
    end
    max
  end

  def twelve_battery_max_joltage
    batteries_needed = 12
    number_to_remove = batteries.length - batteries_needed
    stack = []
    batteries.each_char do |battery|
      while number_to_remove > 0 && !stack.empty? && stack.last < battery
        stack.pop
        number_to_remove -= 1
      end
      stack.push(battery)
    end
    stack.first(batteries_needed).join.to_i
  end
end

JoltageFinder.new.total_joltage
