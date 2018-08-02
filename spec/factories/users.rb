FactoryBot.define do
  factory :user, aliases: %i[author friend] do
    first_name {Faker::Overwatch.hero}
    last_name {Faker::Overwatch.location}
    nickname "ts"
    sequence(:email) { |n| "test_user#{n}@domain.com" }
    password "f4k3p455w0rd"
  end
end
