# frozen_string_literal: true

class ListShiftsEligibilityUseCase
  def self.call(params:, repository: ShiftRepository)
    new(params:, repository:).call
  end

  def initialize(params:, repository: ShiftRepository)
    @params = params
    @repository = repository
  end

  def call
    validate!

    shifts = list.page(params[:page]).per(params[:per_page])
    { success?: true, data: shifts }
  rescue ArgumentError => e
    logger(e.message)

    { success?: false, error: e.message }
  rescue StandardError => e
    logger(e.message)

    raise e
  end

  private

  attr_reader :params, :repository

  def validate!
    raise ArgumentError, 'Facility Id is required' if @params[:facility_id].blank?
    raise ArgumentError, 'Start date is required' if @params[:start_date].blank?
    raise ArgumentError, 'End date is required' if @params[:end_date].blank?
    raise ArgumentError, 'Start date must be before end date' if @params[:start_date] > @params[:end_date]
    raise ArgumentError, 'Facility must be active' unless facility.is_active?
  end

  def facility
    @facility ||= Facility.find(params[:facility_id])
  end

  def list
    repository.call(facility:, start_date: params[:start_date], end_date: params[:end_date],
                    profession: params[:profession])
  end

  def logger(message)
    Rails.logger.error("[#{self.class}] #{message}")
  end
end
