class CreateSimulations < ActiveRecord::Migration[8.1]
  def change
    create_table :simulations do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :generation_number
      t.integer :rows
      t.integer :cols
      t.json :grid_data

      t.timestamps
    end
  end
end
