FactoryBot.define do
  factory :article do
    sequence(:title) { |n| "Sample article #{n}" }
    sequence(:content) { |n| "Content of sample article #{n}" }
    sequence(:slug) { |n| "sample-article-#{n}" }
    association :user
  end
end
