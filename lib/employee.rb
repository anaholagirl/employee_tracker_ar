class Employee < ActiveRecord::Base
  belongs_to :division
  has_many :employees_projects
  has_many :projects, through: :employees_projects
end
