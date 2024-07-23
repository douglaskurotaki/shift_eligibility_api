# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FacilityRequirement, type: :model do
  describe 'associations' do
    it { should belong_to(:facility).class_name('Facility') }
    it { should belong_to(:document).class_name('Document') }
  end

  describe 'factory' do
    it 'has a valid factory' do
      expect(build(:facility_requirement)).to be_valid
    end
  end
end
