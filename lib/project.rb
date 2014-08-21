class Project < ActiveRecord::Base
  has_many :employees_projects
  has_many :employees, through: :employees_projects
end
