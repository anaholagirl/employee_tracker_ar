class CreateEmployee < ActiveRecord::Migration
  def change
    create_table :employees do |t|
      t.string :name
      t.integer :division_id
      t.timestamps
    end
  end
end
