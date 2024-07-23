# frozen_string_literal: true

FactoryBot.define do
  factory :facility do
    name { Faker::Name.name }
    is_active { true }
  end
end
