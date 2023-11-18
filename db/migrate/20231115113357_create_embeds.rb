class CreateEmbeds < ActiveRecord::Migration[7.0]
  def change
    create_table :embeds do |t|
      t.integer :embed_type
      t.string :identifer

      t.timestamps
    end
  end
end
