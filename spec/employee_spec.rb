require "spec_helper"

describe Employee do
  it "has many projects" do
    test_division = Division.create({:name=>"Escape!"})
    test_employee = Employee.create({:name=>"Cindy", :division_id=>test_division.id})
    test_project1 = Project.create({:name=>"Eat lunch", :employee_id=>test_employee.id})
    test_project2 = Project.create({:name=>"Take a nap", :employee_id=>test_employee.id})
    expect(test_employee.projects).to eq [test_project1, test_project2]
  end
end
