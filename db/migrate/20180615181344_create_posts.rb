class CreatePosts < ActiveRecord::Migration[5.1]
  def change
    create_table :posts do |t|
      t.string :content
      t.datetime :timestamp

      t.timestamps
    end
  end
end