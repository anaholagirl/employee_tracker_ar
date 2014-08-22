require 'active_record'

require './lib/employee.rb'
require './lib/division.rb'
require './lib/project.rb'
require './lib/employees_project.rb'

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
  puts "Press 'd' to assign an employee to a division"
  puts "Press 'p' to list all of the projects for an employee"
  puts "Press 'm' to return to the main menu"
  puts "Press 'x' to exit the program"
  menu_choice = gets.chomp
  if menu_choice == 'a'
    add_employee
  elsif menu_choice == 'l'
    list_employees
  elsif menu_choice == 'd'
    assign_employee_to_division
  elsif menu_choice == 'p'
    find_projects_for_employee
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
      if employee.division_id != 0
        puts "#{index+1}. #{employee.name}, Division = #{employee.division.name}"
      else
        puts "#{index+1}. #{employee.name}, Division = Not yet assigned"
      end
    end
  end
  puts "\n"
  employee_array
end

def assign_employee_to_division
  employee_array = list_employees
  puts "\nEnter the number of the employee"
  employee_number = gets.chomp.to_i
  if !employee_array.empty? && employee_number != 0 && employee_number <= employee_array.length
    the_employee = employee_array[employee_number-1]
    division_array = list_divisions
    puts "\nEnter the division number to add the employee to"
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

def find_projects_for_employee
  employee_array = list_employees
  puts "\nEnter the number of the employee"
  employee_number = gets.chomp.to_i
  if !employee_array.empty? && employee_number != 0 && employee_number <= employee_array.length
    the_employee = employee_array[employee_number-1]
    puts "\nThe projects for Employee #{the_employee.name}\n"
    if !the_employee.projects.empty?
      the_employee.projects.each_with_index do |project, index|
        if project.done
          project_status_str = "Completed"
        else
          project_status_str = "In progress"
        end
        employee_project = project.employees_projects.where(:employee_id=>the_employee.id)
        puts "#{index+1}. #{project.name}, #{project_status_str}, " +
                               "#{employee_project.first.contribution}"
      end
    else
      puts "    No projects found"
    end
  else
    puts "\nInvalid employee number, try again"
  end
  puts "\n"
end

def division_menu
  puts "\nWelcome to the Division Menu!\n\n"
  puts "Press 'a' to add a new division"
  puts "Press 'l' to list all the divisions"
  puts "Press 'p' to list all of the projects for a division"
  puts "Press 'm' to return to the main menu"
  puts "Press 'x' to exit the program"
  menu_choice = gets.chomp
  if menu_choice == 'a'
    add_division
  elsif menu_choice == 'l'
    list_divisions
  elsif menu_choice == 'p'
    list_projects_division
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

def list_projects_division
  division_array = list_divisions
  puts "\nEnter the number of the division"
  division_number = gets.chomp.to_i
  if !division_array.empty? && division_number != 0 && division_number <= division_array.length
    the_division = division_array[division_number-1]
    puts "\nThe projects for division #{the_division.name}"
    if !the_division.employees.empty?
      if !the_division.projects.empty?
        the_division.projects.each_with_index do |project, index|
          puts "#{index+1}. #{project.name}"
        end
      else
        puts "\nThere are no projects in the division"
      end
    else
      puts "\nThere are no employees in the division"
    end
  else
    puts "\nInvalid division number, try again"
  end
end

def project_menu
  puts "\nWelcome to the Project Menu!"
  puts "Press 'a' to add a new project"
  puts "Press 'l' to list all the projects"
  puts "Press 'd' to mark a project as done"
  puts "press 'e' to assign an project to a employee"
  puts "Press 'm' to return to the main menu"
  puts "Press 'x' to exit the program"
  menu_choice = gets.chomp
  if menu_choice == 'a'
    add_project
  elsif menu_choice == 'l'
    list_projects
  elsif menu_choice == 'd'
    mark_project_as_done
  elsif menu_choice == 'e'
    assign_project_to_employee
  elsif menu_choice == 'x'
    exit_program
  elsif menu_choice != 'm'
    puts "\nInvalid option, try again"
  end
end

def add_project
  puts "\nEnter new project name"
  project_name = gets.chomp
  new_project = Project.create({:name => project_name, :done=>false})
  puts "\n#{new_project.name} has been added"
end

def list_projects
  puts "\nThe active projects at LinCin Company\n"
  project_array = Project.where(:done=>false).order(:name)
  if !project_array.empty?
    project_array.each_with_index do |project, index|
      puts "#{index+1}. #{project.name}"
      if !project.employees.empty?
        project.employees.each_with_index do |employee, index|
          employee_project = employee.employees_projects.where(:project_id=>project.id)
          puts "    [#{index+1}] #{employee.name}, #{employee_project.first.contribution}"
        end
      else
        puts "    Employee not yet assigned"
      end
    end
  else
    puts "\nThere are no projects in the database"
  end
  puts "\n"
  project_array
end

def assign_project_to_employee
  project_array = list_projects
  puts "\nEnter the number of the project"
  project_number = gets.chomp.to_i
  if !project_array.empty? && (project_number != 0 && project_number <= project_array.length)
    the_project = project_array[project_number-1]
    employee_array = list_employees
    puts "\nEnter the employee number to add to the project"
    employee_number = gets.chomp.to_i
    if !employee_array.empty? && (employee_number != 0 && employee_number <= employee_array.length)
      the_employee = employee_array[employee_number-1]
      puts "Enter what this employee will contribute to the project"
      contribution = gets.chomp
      the_join_entry = EmployeesProject.create(:employee_id=>the_employee.id,
                          :project_id=>the_project.id, :contribution=>contribution)
      puts "\nProject #{the_project.name} added to employee #{the_employee.name}"
    else
      puts "\nInvalid employee number, try again"
    end
  else
    puts "\nInvalid project number, try again"
  end
end

def mark_project_as_done
  project_array = list_projects
  puts "\nEnter the number of the project to mark as complete"
  project_number = gets.chomp.to_i
  if !project_array.empty? && (project_number != 0 && project_number <= project_array.length)
    the_project = project_array[project_number-1]
    the_project.update(:done=>true)
    puts "\nProject #{the_project.name} marked as done!"
  end
end

def exit_program
  puts "\nThank you for using Employee Tracker! Come back soon!\n\n"
  exit
end



main_menu

