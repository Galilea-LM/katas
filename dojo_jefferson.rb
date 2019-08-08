## Reference https://www.codewars.com/kata/help-mrs-jefferson/train/ruby
class Jeffer
  def initialize(students)
    @students = students
  end

  def process
    puts @students
    recursive(@students)
  end

  def recursive(total_student)
     std = total_student
     teams = []
    total_student.times do
      if std >= 2 && std != @students
        teams += [std]
        # teams.each do |num|
        #   total +=num
        # end
        if teams.inject(:+) == @students
          puts "Teams #{teams}"
        end
      else
        recursive(total_student -1)
      end
       std -= 1
    end
  end
end

test = Jeffer.new(200)
test.process
