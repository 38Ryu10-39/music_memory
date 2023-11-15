class SorceryCore < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.string :email,            null: false, index: { unique: true }
      t.string :crypted_password
      t.string :salt
      t.date :birthday
      t.integer :gender, null: false, default: 0
      t.string :x_id
      t.string :avatar
      t.text :profile
      t.string :prefecture_id

      t.timestamps                null: false
    end
  end
end
