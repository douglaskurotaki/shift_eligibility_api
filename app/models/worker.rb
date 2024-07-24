# frozen_string_literal: true

class Worker < ApplicationRecord
  self.table_name = 'Worker'

  enum profession: { CNA: 'CNA', LVN: 'LVN', RN: 'RN' }
  has_many :document_workers, dependent: :destroy, class_name: 'DocumentWorker'
  has_many :documents, through: :document_workers

  has_many :shifts, dependent: :nullify, class_name: 'Shift'

  validates :name, :profession, presence: true
  validates :is_active, inclusion: { in: [true, false] }
end
