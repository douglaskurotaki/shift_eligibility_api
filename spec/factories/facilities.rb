# frozen_string_literal: true

FactoryBot.define do
  factory :facility do
    name { Faker::Name.name }
    is_active { true }
  end

  trait :with_requirements do
    after(:create) do |facility|
      create(:facility_requirement, facility:)
    end
  end

  trait :with_shifts do
    after(:create) do |facility|
      create(:shift, facility:)
    end
  end
end
