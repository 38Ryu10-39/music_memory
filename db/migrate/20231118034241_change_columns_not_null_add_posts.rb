class ChangeColumnsNotNullAddPosts < ActiveRecord::Migration[7.0]
  def change
    change_column :posts, :music_name, :string, null: false
    change_column :posts, :memory, :string, null: false
  end
end
