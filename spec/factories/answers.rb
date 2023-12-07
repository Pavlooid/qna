FactoryBot.define do
  factory :answer do
    body { "MyString" }
    association :question
    association :author

    trait :invalid do
      body { nil }
    end
  end
end
