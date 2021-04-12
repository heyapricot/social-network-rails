FactoryBot.define do
  factory :post do
    sequence(:content) {|n| "I've composed #{n} post"}

    factory :post_with_likes do
      transient do
        like_count { 3 }
      end

      after(:create) do |post, evaluator|
        create_list(:post_action, evaluator.like_count, post: post, action: :like)
      end
    end
  end
end
