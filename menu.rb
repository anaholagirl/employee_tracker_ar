require 'active_record'

require './lib/employee.rb'
require './lib/division.rb'
require 'pry'

database_configurations = YAML::load(File.open('./db/config.yml'))
development_configuration = database_configurations['development']
ActiveRecord::Base.establish_connection(development_configuration)

def main_menu

  puts "\n"
  puts "*" * 46
  puts "Welcome to LinCin's Employee Tracker!\n"
  puts "*" * 46

  menu_choice = ""
  while menu_choice != 'x' && menu_choice != 'm'
    puts "\nPress 'e' to enter the employee menu"
    puts "Press 'd' to enter the division menu"
    puts "Press 'p' to enter the project menu"
    puts "Press 'm' to go to the main menu (this menu)"
    puts "Press 'x' to exit"
    menu_choice = gets.chomp
    case menu_choice
    when 'e'
      employee_menu
    when 'd'
      division_menu
    when 'p'
      project_menu
    when 'm'
    when 'x'
      exit_program
    else
      puts "\nInvalid option, try again"
    end
  end
end

def employee_menu
  puts "\nWelcome to the Employee Menu!"
  puts "Press 'a' to add a new employee"
  puts "Press 'l' to list all the employees"
  puts "press 'd' to assign an employee to a division"
  puts "Press 'm' to return to the main menu"
  puts "Press 'x' to exit the program"
  menu_choice = gets.chomp
  if menu_choice == 'a'
    add_employee
  elsif menu_choice == 'l'
    list_employees
  elsif menu_choice == 'd'
    assign_employee_to_division
  elsif menu_choice == 'x'
    exit_program
  elsif menu_choice != 'm'
    puts "\nInvalid option, try again"
  end
end

def add_employee
  puts "\nEnter new employee name"
  employee_name = gets.chomp
  new_employee = Employee.create({:name => employee_name, :division_id => 0})
  puts "\n#{new_employee.name} has been added"
end

def list_employees
  puts "\nThe employees at LinCin Company\n"
  employee_array = Employee.all.order(:name)
  if employee_array.empty?
    puts "\nThere are no employees in the database"
  else
    employee_array.each_with_index do |employee, index|
      puts "#{index+1}. #{employee.name}, Division = #{employee.division_id}"
    end
  end
  puts "\n"
  employee_array
end

def assign_employee_to_division
  employee_array = list_employees
  puts "\nEnter the number of the employee"
  employee_number = gets.chomp.to_i
  if !employee_array.empty? && (employee_number != 0 && employee_number <= employee_array.length)
    the_employee = employee_array[employee_number-1]
    division_array = list_divisions
    puts "\nEnter the division number to add the employee"
    division_number = gets.chomp.to_i
    if !division_array.empty? && (division_number != 0 && division_number <= division_array.length)
      the_division = division_array[division_number-1]
      the_employee.update(:division_id=>the_division.id)
      puts "\nEmployee #{the_employee.name} added to Division #{the_division.name}"
    else
      puts "\nInvalid division number, try again"
    end
  else
    puts "\nInvalid employee number, try again"
  end
end

def division_menu
  puts "\nWelcome to the Division Menu!\n\n"
  puts "Press 'a' to add a new division"
  puts "Press 'l' to list all the divisions"
  puts "Press 'm' to return to the main menu"
  puts "Press 'x' to exit the program"
  menu_choice = gets.chomp
  if menu_choice == 'a'
    add_division
  elsif menu_choice == 'l'
    list_divisions
  elsif menu_choice == 'x'
    exit_program
  elsif menu_choice != 'm'
    puts "\nInvalid option, try again"
  end
end

def add_division
  puts "\nEnter new division name"
  division_name = gets.chomp
  new_division = Division.create({:name => division_name})
  puts "\n#{new_division.name} has been added"
  puts "\n"
end

def list_divisions
  puts "\nThe divisions at LinCin Company\n"
  division_array = Division.all.order(:name)
  division_array.each_with_index do |division, index|
    puts "#{index+1}. #{division.name}"
  end
  puts "\n"
  division_array
end

def project_menu

end

def exit_program
  puts "\nThank you for using Employee Tracker! Come back soon!\n\n"
  exit
end



main_menu

