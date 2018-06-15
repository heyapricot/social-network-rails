FactoryBot.define do
  factory :post do
    sequence(:content) {|n| "I've composed #{n} post"}
    timestamp {DateTime.current}
  end
end
