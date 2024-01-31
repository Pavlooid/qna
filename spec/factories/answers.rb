FactoryBot.define do
  factory :answer do
    body { "MyString" }
    association :question
    association :author

    trait :invalid do
      body { nil }
    end

    factory :answer_with_file do
      after(:create) do |answer|
        answer.files.attach(io: File.open("#{Rails.root}/spec/rails_helper.rb"), filename: 'rails_helper.rb', content_type: 'application/rb')
      end
    end
  end
end
