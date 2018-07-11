FactoryBot.define do
  factory :post do
    sequence(:content) {|n| "I've composed #{n} post"}
  end
end
