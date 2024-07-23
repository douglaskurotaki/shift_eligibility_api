# frozen_string_literal: true

require 'rails_helper'
require 'n_plus_one_control/rspec'

RSpec.describe ShiftRepository, type: :model do
  let(:facility) { create(:facility, :with_requirements, is_active: true) }
  let(:inactive_facility) { create(:facility, is_active: false) }
  let(:start_date) { 1.day.ago }
  let(:end_date) { 3.days.from_now }
  let(:profession) { 'CNA' }

  let!(:shift) do
    create(:shift, facility:, start: 2.days.from_now, end: 3.days.from_now, profession:,
                   is_deleted: false, worker_id: nil)
  end

  let!(:claimed_shift) do
    create(:shift, facility:, start: 2.days.from_now, end: 3.days.from_now, profession:,
                   is_deleted: false, worker_id: create(:worker).id)
  end

  let!(:inactive_facility_shift) do
    create(:shift, facility: inactive_facility, start: 2.days.from_now, end: 3.days.from_now, profession:,
                   is_deleted: false, worker_id: nil)
  end

  describe '.call' do
    context 'when facility is active' do
      it 'filters by profession if provided' do
        result = ShiftRepository.call(facility:, start_date:, end_date:, profession:)

        expect(result).to include(shift)
        expect(result).not_to include(claimed_shift, inactive_facility_shift)
      end

      it 'does not filter by profession if not provided' do
        result = ShiftRepository.call(facility:, start_date:, end_date:)

        expect(result).to include(shift)
        expect(result).not_to include(claimed_shift, inactive_facility_shift)
      end
    end

    context 'when facility is inactive' do
      it 'does not return shifts' do
        result = ShiftRepository.call(facility: inactive_facility, start_date:, end_date:)

        expect(result).to be_empty
      end
    end

    context 'when an error occurs' do
      before do
        allow(Shift).to receive(:includes).and_raise(StandardError, 'test error')
      end

      it 'logs the error and raises it' do
        expect(Rails.logger).to receive(:error).with('[ShiftRepository] test error')
        expect do
          ShiftRepository.call(facility:, start_date:, end_date:)
        end.to raise_error(StandardError, 'test error')
      end
    end
  end

  context 'N+1', :n_plus_one do
    before do
      create_list(:shift, 20, start: 2.days.from_now, end: 3.days.from_now, facility:)
    end

    it 'does not have an N+1 query' do
      expect do
        ShiftRepository.new(facility:, start_date:, end_date:).call.map { |shift| shift.facility.name }
      end.to perform_constant_number_of_queries.exactly(2)
    end
  end
end
