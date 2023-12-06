FactoryBot.define do
  factory :question do
    title { "MyString" }
    body { "MyText" }
    association :author

    trait :invalid do
      title { nil }
    end

    trait :with_answers do
      after(:create) do |question|
        create_list(:answer, 5, question: question)
      end
    end
  end
end
