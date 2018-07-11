class RemoveTimestampFromPosts < ActiveRecord::Migration[5.1]
  def change
    remove_column :posts, :timestamp, :datetime
  end
end
