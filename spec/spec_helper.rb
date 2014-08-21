require 'active_record'
require 'rspec'

require 'employee'
require 'division'
require 'project'
require 'employees_project'

database_configurations = YAML::load(File.open('./db/config.yml'))
test_configuration = database_configurations['test']
ActiveRecord::Base.establish_connection(test_configuration)

RSpec.configure do |config|
  config.after(:each) do
    Employee.all.each { |employee| employee.destroy }
  end
  config.after(:each) do
    Division.all.each { |division| division.destroy }
  end
end
