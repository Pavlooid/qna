FactoryBot.define do
  factory :answer do
    body { "MyString" }
    correct { true }
    association :question
    association :author

    trait :invalid do
      body { nil }
    end
  end
end
