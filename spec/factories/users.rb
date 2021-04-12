FactoryBot.define do
  factory :user, aliases: %i[author friend] do
    first_name {Faker::Overwatch.hero}
    last_name {Faker::Overwatch.location}
    nickname { "ts" }
    sequence(:email) { |n| "test_user#{n}@domain.com" }
    password { "f4k3p455w0rd" }

    factory :user_with_posts do
      transient do
        posts_count { 2 }
      end

      after(:create) do |user, evaluator|
        create_list(:post, evaluator.posts_count, author: user)
      end
    end

  end
end
