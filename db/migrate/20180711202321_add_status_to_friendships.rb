class AddStatusToFriendships < ActiveRecord::Migration[5.1]
  def change
    add_column :friendships, :status, :integer, default: 0
  end
end
