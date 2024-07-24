# frozen_string_literal: true

class AssignWorkerToShiftUseCase
  def self.call(shift:, worker:)
    new(shift:, worker:).call
  end

  def initialize(shift:, worker:)
    @shift = shift
    @worker = worker
  end

  def call
    validate!

    shift.update!(worker:)
    { success?: true, data: shift }
  rescue ArgumentError => e
    { success?: false, error: e.message }
  rescue ActiveRecord::RecordInvalid => e
    { success?: false, error: e.record.errors.full_messages.join(', ') }
  end

  private

  attr_reader :shift, :worker

  def validate!
    validate_facility_active
    validate_worker_present
    validate_worker_active
    validate_worker_profession
    validate_no_conflicting_shift
    validate_worker_documents
  end

  def validate_facility_active
    raise ArgumentError, 'Facility must be active' unless shift.facility.is_active?
  end

  def validate_worker_present
    raise ArgumentError, 'There are worker assigned' if shift.worker.present?
  end

  def validate_worker_active
    raise ArgumentError, 'Worker must be active' unless worker.is_active?
  end

  def validate_worker_profession
    return if worker.profession == shift.profession

    raise ArgumentError, 'Worker profession must match the shift profession'
  end

  def validate_no_conflicting_shift
    return unless conflicting_shift_exists?

    raise ArgumentError, 'Worker cannot have a conflicting shift'
  end

  def conflicting_shift_exists?
    Shift.where(worker_id: worker.id)
         .where('start < ? AND "end" > ?', shift.end, shift.start)
         .where(is_deleted: false)
         .exists?
  end

  def validate_worker_documents
    return if worker_has_all_required_documents?

    raise ArgumentError, 'Worker must have all required documents for the facility'
  end

  def worker_has_all_required_documents?
    required_documents = shift.facility.facility_requirements.pluck(:document_id)
    worker_documents = worker.document_workers.pluck(:document_id)
    (required_documents - worker_documents).empty?
  end
end
