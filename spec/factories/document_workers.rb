# frozen_string_literal: true

FactoryBot.define do
  factory :document_worker do
    worker
    document
  end
end
