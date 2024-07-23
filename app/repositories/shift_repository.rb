# frozen_string_literal: true

class ShiftRepository
  def self.call(facility:, start_date:, end_date:, profession: nil)
    new(facility:, start_date:, end_date:, profession:).call
  end

  def initialize(facility:, start_date:, end_date:, profession: nil)
    @facility = facility
    @start_date = start_date
    @end_date = end_date
    @profession = profession
  end

  def call
    Shift.joins(facility: :facility_requirements)
         .includes(:facility)
         .left_joins(:worker)
         .where(facility:)
         .where(facility: { is_active: true })
         .where(is_deleted: false, worker_id: nil)
         .where(profession_condition)
         .where('"Shift".start >= ? AND "Shift".end <= ?', start_date, end_date)
         .order(:start)
  rescue StandardError => e
    Rails.logger.error("[#{self.class}] #{e.message}")
    raise e
  end

  private

  attr_reader :facility, :start_date, :end_date

  def profession_condition
    return {} if @profession.blank?

    { profession: @profession }
  end
end
