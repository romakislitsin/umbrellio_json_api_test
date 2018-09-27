class CreateRatings < ActiveRecord::Migration[5.2]
  def change
    create_table :ratings do |t|
      t.references :post, foreign_key: true, null: false
      t.integer :rate, null: false
    end
  end
end
