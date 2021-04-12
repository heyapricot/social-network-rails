FactoryBot.define do
  factory :friendship do
    user
    friend

    factory :friendship_with_posts do
      transient do
        posts_count { 2 }
      end

      after(:create) do |friendship, evaluator|
        create_list(:post, evaluator.posts_count, author: friendship.friend, content: Faker::Overwatch.quote)
      end
    end
  end
end
