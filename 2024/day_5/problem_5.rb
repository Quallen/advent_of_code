require 'pry-byebug'

class PrintQueue
  attr_accessor :input, :rules, :print_jobs, :valid_jobs, :invalid_jobs
  def initialize
    @input = File.read('problem_5_input.txt').lines.map(&:chomp)
    @rules, @print_jobs = [], []
    extract_rules_and_jobs_from_input
    @valid_jobs, @invalid_jobs = [], []
    print_jobs.each do |job|
      valid_job?(job) ? valid_jobs << job : invalid_jobs << job
    end
    fix_invalid_jobs
  end

  def extract_rules_and_jobs_from_input
    rules_input = input.select{|line| line.include?('|')}
    rules_input.each do |rule|
      rules << Rule.new(input: rule)
    end
    print_jobs_input = input.select{|line| line.include?(',')}
    print_jobs_input.each do |job|
      print_jobs << Job.new(input: job)
    end
  end

  def valid_job?(job)
    job.pages.each_with_index do |page, index|
      #next if job.first_page == page
      return true if index == job.pages.count - 1
      relevant_rules = rules_for(page)
      # 75,47,61,53,29
      relevant_rules.each do |rule|
        next if !job.pages.include?(rule.number)
        return false if job.pages.find_index(rule.number) > job.pages.find_index(rule.before)
      end
    end
  end

  def rules_for(page)
    @rules.select{|rule| rule.before == page}
  end

  def sum_jobs_middle_page
    %w(valid_jobs invalid_jobs).each do |jobs|
      sum = 0
      send(jobs).each do |job|
        middle_index = job.pages.length / 2
        sum += job.pages[middle_index]
      end
      puts sum
    end
  end

  def fix_invalid_jobs
    invalid_jobs.each do |job|
      until valid_job?(job)
        job.pages.each_with_index do |page, index|
          relevant_rules = rules_for(page)
          relevant_rules.each do |rule|
            next if !job.pages.include?(rule.number)
            number_index = job.pages.find_index(rule.number)
            before_index = job.pages.find_index(rule.before)
            if number_index > before_index
              swap = job.pages[number_index]
              job.pages[number_index] = job.pages[before_index]
              job.pages[before_index] = swap
            end
          end
        end
      end
    end
  end

  class Rule
    attr_accessor :number, :before
    def initialize(input: )
      rule = input.split('|').map(&:to_i)
      @number = rule.first
      @before = rule.last
    end
  end

  class Job
    attr_accessor :pages
    def initialize(input: )
      @pages = input.split(',').map(&:to_i)
    end
  end
end

queue = PrintQueue.new
queue.sum_jobs_middle_page
