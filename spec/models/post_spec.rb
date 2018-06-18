require 'rails_helper'

RSpec.describe Post, type: :model do

  let(:user){FactoryBot.create(:user)}
  let(:other){FactoryBot.create(:user)}
  let(:post){FactoryBot.create(:post, user_id: user.id)}

  it "Can be liked by a user" do
    post.liked_by_users << other
    expect(post.liked_by_users).to include(other)
  end

end
