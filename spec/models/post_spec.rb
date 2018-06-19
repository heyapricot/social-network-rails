require 'rails_helper'

RSpec.describe Post, type: :model do

  let(:user){FactoryBot.create(:user)}
  let(:other){FactoryBot.create(:user)}
  let(:post){FactoryBot.create(:post, user_id: user.id)}

  it "Can be liked by a user" do
    post.likers << other
    expect(post.likers).to include(other)
  end

  it "Can keep track of the users who viewed the post" do
    post.viewers << other
    expect(post.viewers).to include(other)
  end

end
