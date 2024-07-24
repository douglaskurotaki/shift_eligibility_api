# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AssignWorkerToShiftUseCase, type: :use_case do
  let(:facility) { create(:facility, is_active: true) }
  let(:inactive_facility) { create(:facility, is_active: false) }
  let(:worker) { create(:worker, is_active: true, profession: 'CNA') }
  let(:inactive_worker) { create(:worker, is_active: false, profession: 'CNA') }
  let(:shift) { create(:shift, facility:, profession: 'CNA') }

  before do
    create(:facility_requirement, facility:, document: create(:document))
    create(:document_worker, worker:, document: facility.facility_requirements.first.document)
  end

  context 'when all conditions are met' do
    it 'assigns a worker to a shift successfully' do
      response = described_class.call(shift:, worker:)

      expect(response[:success?]).to be true
      expect(response[:data].worker).to eq(worker)
    end
  end

  context 'when facility is inactive' do
    before { shift.update(facility: inactive_facility) }

    it 'returns an error' do
      response = described_class.call(shift:, worker:)

      expect(response[:success?]).to be false
      expect(response[:error]).to eq('Facility must be active')
    end
  end

  context 'when there are worker assigned' do
    before { shift.update(worker: create(:worker)) }

    it 'returns an error' do
      response = described_class.call(shift:, worker:)

      expect(response[:success?]).to be false
      expect(response[:error]).to eq('There are worker assigned')
    end
  end

  context 'when worker is inactive' do
    before { worker.update(is_active: false) }

    it 'returns an error' do
      response = described_class.call(shift:, worker:)

      expect(response[:success?]).to be false
      expect(response[:error]).to eq('Worker must be active')
    end
  end

  context 'when worker profession does not match shift profession' do
    before { worker.update(profession: 'RN') }

    it 'returns an error' do
      response = described_class.call(shift:, worker:)

      expect(response[:success?]).to be false
      expect(response[:error]).to eq('Worker profession must match the shift profession')
    end
  end

  context 'when worker has a conflicting shift' do
    before do
      create(:shift, facility:, worker:, profession: 'CNA', start: 1.hour.ago, end: 1.hour.from_now)
    end

    it 'returns an error' do
      response = described_class.call(shift:, worker:)

      expect(response[:success?]).to be false
      expect(response[:error]).to eq('Worker cannot have a conflicting shift')
    end
  end

  context 'when worker does not have all required documents' do
    before { worker.document_workers.destroy_all }

    it 'returns an error' do
      response = described_class.call(shift:, worker:)

      expect(response[:success?]).to be false
      expect(response[:error]).to eq('Worker must have all required documents for the facility')
    end
  end
end
