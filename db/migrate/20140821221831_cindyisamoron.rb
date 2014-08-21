class Cindyisamoron < ActiveRecord::Migration
  def change
    drop_table :employees_projects
    create_table :employees_projects, id: false do |t|
      t.belongs_to :employee
      t.belongs_to :project
    end
  end
end
