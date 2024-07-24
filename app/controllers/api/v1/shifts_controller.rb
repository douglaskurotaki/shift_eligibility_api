# frozen_string_literal: true

module Api
  module V1
    class ShiftsController < ApplicationController
      before_action :set_shift, :set_worker, only: %i[assign_worker]

      def index
        response = ::ListShiftsEligibilityUseCase.call(params: builder_list)
        if response[:success?]
          @shifts = response[:data]
        else
          render json: { error: response[:error] }, status: :unprocessable_entity
        end
      rescue ActiveRecord::RecordNotFound => e
        render json: { error: e.message }, status: :not_found
      end

      def assign_worker
        response = AssignWorkerToShiftUseCase.call(shift: @shift, worker: @worker)
        if response[:success?]
          @shift = response[:data]
          render :show, status: :ok
        else
          render json: { error: response[:error] }, status: :unprocessable_entity
        end
      rescue ActiveRecord::RecordNotFound => e
        render json: { error: e.message }, status: :not_found
      end

      private

      def set_shift
        @shift = Shift.find(params[:shift_id])
      end

      def set_worker
        @worker = Worker.find(shift_params[:worker_id])
      end

      def builder_list
        {
          facility_id: params[:facility_id],
          start_date: params[:start_date],
          end_date: params[:end_date],
          profession: params[:profession],
          page: params[:page] || 1,
          per: params[:per] || 10
        }
      end

      def shift_params
        params.require(:shift).permit(:worker_id)
      end
    end
  end
end
