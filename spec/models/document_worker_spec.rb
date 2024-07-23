# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DocumentWorker, type: :model do
  describe 'associations' do
    it { should belong_to(:worker).class_name('Worker') }
    it { should belong_to(:document).class_name('Document') }
  end

  describe 'factory' do
    it 'has a valid factory' do
      expect(build(:document_worker)).to be_valid
    end
  end
end
