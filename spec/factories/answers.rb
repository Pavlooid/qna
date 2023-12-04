FactoryBot.define do
  factory :answer do
    body { "MyString" }
    correct { true }
    association :question

    trait :invalid do
      body { nil }
    end
  end
end
