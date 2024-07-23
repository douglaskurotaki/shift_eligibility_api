# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Worker, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:profession) }
    it { should validate_inclusion_of(:is_active).in_array([true, false]) }
  end

  describe 'associations' do
    it { should have_many(:document_workers).dependent(:destroy) }
    it { should have_many(:documents).through(:document_workers) }
    it { should have_many(:shifts).dependent(:destroy) }
  end

  describe 'factory' do
    it 'has a valid factory' do
      expect(build(:worker)).to be_valid
    end
  end
end
