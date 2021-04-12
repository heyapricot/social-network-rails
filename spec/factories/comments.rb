FactoryBot.define do
  factory :comment do
    content { "MyString" }
    post { nil }
    user { nil }
  end
end
