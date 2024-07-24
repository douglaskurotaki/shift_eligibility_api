# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'api/shifts', type: :request do
  let('Accept') { 'application/vnd.shifts.v1' }

  path '/api/shifts' do
    get 'List shifts eligibility' do
      tags 'Shifts'
      produces 'application/json'
      consumes 'application/json'

      parameter name: :page, in: :query, type: :integer, required: false, description: 'Page number'
      parameter name: :per, in: :query, type: :integer, required: false, description: 'Number of items per page'
      parameter name: :profession, in: :query, type: :integer, required: false, description: 'Number of items per page'
      parameter name: :facility_id, in: :query, type: :integer, required: true, description: 'Facility ID'
      parameter name: :start_date, in: :query, type: :string, required: true, description: 'Start date'
      parameter name: :end_date, in: :query, type: :string, required: true, description: 'End date'
      parameter name: :profession, in: :query, type: :string, required: false, description: 'Profession type', schema: {
        type: :string,
        enum: %w[CNA LVN RN],
        example: 'RN'
      }

      let(:page) { 1 }
      let(:per) { 10 }
      let(:facility) { create(:facility, :with_requirements) }
      let(:facility_id) { facility.id }
      let(:start_date) { 1.day.ago }
      let(:end_date) { 3.days.from_now }

      response '200', 'shifts found' do
        schema type: :object,
               properties: {
                 shifts: {
                   type: :array,
                   items: {
                     '$ref' => '#/components/schemas/shift'
                   }
                 },
                 pagination: {
                   type: :object,
                   properties: {
                     current_page: { type: :integer },
                     next_page: { type: :integer, 'x-nullable': true },
                     prev_page: { type: :integer, 'x-nullable': true },
                     total_pages: { type: :integer },
                     total_count: { type: :integer }
                   }
                 }
               }

        let(:shifts) { create_list(:shift, 10, facility:) }
        let(:use_case_response) do
          {
            success?: true,
            data: Shift.where(id: shifts.pluck(:id)).page
          }
        end

        before do
          allow(ListShiftsEligibilityUseCase).to receive(:call).and_return(use_case_response)
        end

        run_test!
      end

      response '422', 'unprocessable entity' do
        let(:facility) { create(:facility, :with_requirements, is_active: false) }
        let(:facility_id) { facility.id }

        let(:use_case_response) do
          {
            success?: false,
            error: 'Facility must be active'
          }
        end

        before do
          allow(ListShiftsEligibilityUseCase).to receive(:call).and_return(use_case_response)
        end

        run_test!
      end

      response '404', 'facility not found' do
        let(:facility_id) { 0 }

        before do
          allow(ListShiftsEligibilityUseCase).to receive(:call).and_raise(ActiveRecord::RecordNotFound,
                                                                          'Facility not found')
        end

        run_test!
      end
    end
  end
end
