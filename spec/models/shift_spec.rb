# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Shift, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:start) }
    it { should validate_presence_of(:end) }
    it { should validate_presence_of(:profession) }
    it { should validate_inclusion_of(:is_deleted).in_array([true, false]) }
  end

  describe 'associations' do
    it { should belong_to(:facility).class_name('Facility') }
    it { should belong_to(:worker).optional(true).class_name('Worker') }
  end

  describe 'enums' do
    it 'defines profession enum with correct values' do
      expect(Shift.professions).to include('CNA' => 'CNA', 'LVN' => 'LVN', 'RN' => 'RN')
    end
  end

  describe 'factory' do
    it 'has a valid factory' do
      expect(build(:shift)).to be_valid
    end
  end
end
