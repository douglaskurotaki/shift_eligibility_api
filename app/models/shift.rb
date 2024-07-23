# frozen_string_literal: true

class Shift < ApplicationRecord
  self.table_name = 'Shift'

  enum profession: { CNA: 'CNA', LVN: 'LVN', RN: 'RN' }
  belongs_to :facility, class_name: 'Facility'
  belongs_to :worker, optional: true, class_name: 'Worker'

  validates :start, :end, :profession, presence: true
  validates :is_deleted, inclusion: { in: [true, false] }
end
