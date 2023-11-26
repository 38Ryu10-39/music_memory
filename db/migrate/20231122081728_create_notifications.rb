class CreateNotifications < ActiveRecord::Migration[7.0]
  def change
    create_table :notifications do |t|
      t.references :notifiable, polymorphic: true, null: false
      t.references :sender, User: true, null: false, foreign_key: { to_table: :users }
      t.references :receiver, User: true, null: false, foreign_key: { to_table: :users }
      t.boolean :is_read, default: false, null: false

      t.timestamps
    end
  end
end
