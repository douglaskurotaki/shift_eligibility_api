# frozen_string_literal: true

module Api
  module V1
    class ShiftsController < ApplicationController
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
        params.require(:shift).permit(:worker_id, :facility_id, :start_date, :end_date, :profession)
      end
    end
  end
end
