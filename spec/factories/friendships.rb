FactoryBot.define do
  factory :friendship do
    user
    friend

    factory :friendship_with_posts do
      transient { posts_count { 2 } }

      after(:create) do |friendship, evaluator|
        create_list(
          :post,
          evaluator.posts_count,
          author: friendship.friend,
          content: Faker::Games::Overwatch.quote
        )
      end
    end
  end
end
