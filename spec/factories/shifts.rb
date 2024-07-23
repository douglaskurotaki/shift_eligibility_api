# frozen_string_literal: true

FactoryBot.define do
  factory :shift do
    start { Time.now }
    self.end { Time.now + 5.hours }
    profession { 'CNA' }
    is_deleted { false }
    facility
  end
end
