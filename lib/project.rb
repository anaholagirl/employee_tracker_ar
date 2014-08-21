class Project < ActiveRecord::Base
  has_many :employees, through :employee_projects
end
