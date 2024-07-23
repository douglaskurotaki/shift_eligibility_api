# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Facility, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_inclusion_of(:is_active).in_array([true, false]) }
  end

  describe 'associations' do
    it { should have_many(:facility_requirements).dependent(:destroy).class_name('FacilityRequirement') }
    it { should have_many(:documents).through(:facility_requirements) }

    it { should have_many(:shifts).dependent(:destroy).class_name('Shift') }
  end

  describe 'factory' do
    it 'has a valid factory' do
      expect(build(:facility)).to be_valid
    end
  end
end
