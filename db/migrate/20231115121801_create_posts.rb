class CreatePosts < ActiveRecord::Migration[7.0]
  def change
    create_table :posts do |t|
      t.string :music_name
      t.text :memory
      t.references :user, null: false, foreign_key: true
      t.references :embed, foreign_key: true
      t.integer :age_group
      t.integer :prefecture_id

      t.timestamps
    end
  end
end
