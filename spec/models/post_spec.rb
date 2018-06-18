require 'rails_helper'

RSpec.describe Post, type: :model do

  let(:user){FactoryBot.create(:user)}
  let(:other){FactoryBot.create(:user)}
  let(:post){FactoryBot.create(:post, user_id: user.id)}

  it "Can be liked by a user" do
    post.users_who_liked << other
    expect(post.users_who_liked).to include(other)
  end

  it "Can keep track of the users who viewed the post" do
    post.users_who_viewed << other
    expect(post.users_who_viewed).to include(other)
  end

end
