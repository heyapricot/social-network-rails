class PostAction < ApplicationRecord
  belongs_to :post
  belongs_to :user
  enum action: %i[comment like view]
  validates_presence_of :content, if: :comment?
  validates_absence_of :content, unless: :comment?
  validates_uniqueness_of :user, scope: [:post, :action], if: :like?
end
