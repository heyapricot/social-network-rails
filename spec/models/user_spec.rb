require 'rails_helper'

RSpec.describe User, type: :model do

  let(:user){FactoryBot.create(:user)}

  it "has many posts" do

    post_quantity = 3

    post_quantity.times {FactoryBot.create(:post, author: user)}
    expect(user.posts.length).to eq(post_quantity)
  end
end
