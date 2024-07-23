# frozen_string_literal: true

class Document < ApplicationRecord
  self.table_name = 'Document'

  has_many :facility_requirements, dependent: :destroy, class_name: 'FacilityRequirement'
  has_many :facilities, through: :facility_requirements

  has_many :document_workers, dependent: :destroy, class_name: 'DocumentWorker'
  has_many :workers, through: :document_workers

  validates :name, presence: true
  validates :is_active, inclusion: { in: [true, false] }
end
