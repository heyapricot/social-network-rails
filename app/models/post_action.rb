class PostAction < ApplicationRecord
  belongs_to :post
  belongs_to :user
  enum action: %i[comment like view]
end
