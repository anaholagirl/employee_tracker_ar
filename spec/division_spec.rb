require "spec_helper"

describe Division do
  it "has many employees" do
    test_division = Division.create({:name=>"Escape!"})
    test_employee1 = Employee.create({:name=>"Cindy", :division_id=>test_division.id})
    test_employee2 = Employee.create({:name=>"Linda", :division_id=>test_division.id})
    expect(test_division.employees).to eq [test_employee1, test_employee2]
  end
end
