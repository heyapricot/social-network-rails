class CreatePostActions < ActiveRecord::Migration[5.1]
  def change
    create_table :post_actions do |t|
      t.references :post, foreign_key: true
      t.references :user, foreign_key: true
      t.integer :action
      t.string :content

      t.timestamps
    end
  end
end
