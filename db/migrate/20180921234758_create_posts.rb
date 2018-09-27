class CreatePosts < ActiveRecord::Migration[5.2]
  def change
    create_table :posts do |t|
      t.references :user, foreign_key: true
      t.string :title, null: false
      t.text :content, null: false
      t.inet :user_ip
      t.float :average_rating, default: 0.0, null: false
    end
  end
end
