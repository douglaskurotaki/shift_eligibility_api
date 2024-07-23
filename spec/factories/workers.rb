# frozen_string_literal: true

FactoryBot.define do
  factory :worker do
    name { Faker::Name.name }
    is_active { true }
    profession { 'CNA' }
  end
end
