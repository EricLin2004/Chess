class Employee
  attr_accessor :name, :title, :salary, :manager

  def calculate_bonus(multiplier)
    bonus = salary * multiplier
  end
end

class Manager < Employee
  attr_accessor :employees

  def initialize
    @employees = []
  end

  def assign_employee(employee)
    @employees << employee
    employee.manager = self
  end

  def calculate_total_salaries
    total_salaries = 0
    employees.each do |employee|
      if employee.is_a?(Manager)
        total_salaries += calculate_total_salaries
      else
        total_salaries += employee.salary
      end
    end
    total_salaries
  end

  def calculate_bonus(multiplier)
    bonus = calculate_total_salaries * multiplier
  end
end