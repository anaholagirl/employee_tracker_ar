class RedoEmployeesProjects < ActiveRecord::Migration
  def change

    drop_table :employees_projects
    create_table :employees_projects, id: false do |t|
      t.belongs_to :employee
      t.belongs_to :project
    end

    remove_column :projects, :employee_id
    add_column :projects, :start_date, :datetime
    add_column :projects, :end_date, :datetime

  end
end
