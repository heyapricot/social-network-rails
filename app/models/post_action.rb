class PostAction < ApplicationRecord
  belongs_to :post
  belongs_to :user
  enum action: %i[comment like view]
  validates :content, absence: true, unless: :comment?
  validates :content, presence: true, if: :comment?
  validates :user, uniqueness: true, if: :like?
end
