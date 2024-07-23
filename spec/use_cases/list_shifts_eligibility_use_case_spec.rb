# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ListShiftsEligibilityUseCase do
  let(:facility) { create(:facility, :with_requirements, :with_shifts, is_active: true) }
  let(:inactive_facility) { create(:facility, is_active: false) }
  let(:start_date) { 1.day.ago }
  let(:end_date) { 3.days.from_now }
  let(:profession) { 'CNA' }
  let(:repository) { instance_double(ShiftRepository) }
  let(:params) do
    {
      facility_id: facility.id,
      start_date:,
      end_date:,
      profession:,
      page: 1,
      per_page: 10
    }
  end

  describe '.call' do
    subject { described_class.call(params:) }

    context 'with valid params' do
      let(:shifts) { double('Shifts') }

      before do
        allow(ShiftRepository).to receive(:call).and_return(Shift.all)
        allow(Shift).to receive(:page).and_return(shifts)
        allow(shifts).to receive(:per).and_return(shifts)
      end

      it 'returns shifts' do
        result = subject

        expect(result[:success?]).to be(true)
        expect(result[:data]).to eq(shifts)
      end
    end

    context 'with missing facility_id' do
      before { params.delete(:facility_id) }

      it 'returns an error' do
        result = subject

        expect(result[:success?]).to be(false)
        expect(result[:error]).to eq('Facility Id is required')
      end
    end

    context 'with missing start_date' do
      before { params.delete(:start_date) }

      it 'returns an error' do
        result = subject

        expect(result[:success?]).to be(false)
        expect(result[:error]).to eq('Start date is required')
      end
    end

    context 'with missing end_date' do
      before { params.delete(:end_date) }

      it 'returns an error' do
        result = subject

        expect(result[:success?]).to be(false)
        expect(result[:error]).to eq('End date is required')
      end
    end

    context 'with start_date after end_date' do
      before { params[:start_date] = params[:end_date] + 1.day }

      it 'returns an error' do
        result = subject

        expect(result[:success?]).to be(false)
        expect(result[:error]).to eq('Start date must be before end date')
      end
    end

    context 'with inactive facility' do
      before { params[:facility_id] = inactive_facility.id }

      it 'returns an error' do
        result = subject

        expect(result[:success?]).to be(false)
        expect(result[:error]).to eq('Facility must be active')
      end
    end

    context 'when repository raises an error' do
      before do
        allow(ShiftRepository).to receive(:call).and_raise(StandardError, 'test error')
      end

      it 'raises error' do
        expect { subject }.to raise_error(StandardError, 'test error')
      end
    end
  end
end
