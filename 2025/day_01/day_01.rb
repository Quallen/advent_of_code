require 'pry-byebug'

class Dial
  attr_reader :input

  def initialize
    @input = File.read('input.txt').lines.map(&:chomp)
    @position = 50
    @password_count = 0
  end

  def find_password
    input.each do |line|
      update_position(direction: line[0] == 'L' ? :left : :right, value: line[1..].to_i)
      @password_count += 1 if @position == 0
    end
    puts @password_count
  end

  def update_position(direction:, value:)
    case direction
    when :left
      value.times do
        @position -= 1
        @position = @position < 0 ? 99 : @position
      end
    when :right
      value.times do
        @position += 1
        @position = @position > 99 ? 0 : @position
      end
    end
  end
end

Dial.new.find_password
