require 'rails_helper'

RSpec.feature "NavbarActions", type: :feature do

  number_of_friends = 4

  let(:user){FactoryBot.create(:user)}
  let(:friends) do
    f = []
    number_of_friends.times {f.push(FactoryBot.create(:user))}
    f
  end

  pending "Visit root page with friend requests pending" do

    friends.each {|f| user.requesters << f}

    visit user_path(user.id)

    expect(user.friend_requests.count).to eq(number_of_friends)
    #save_and_open_page
    expect(page).to have_text("#{number_of_friends}")

  end



end
