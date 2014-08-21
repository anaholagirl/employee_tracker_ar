class CreateProject < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :name
      t.integer :employee_id
      t.timestamps
    end
  end
end
