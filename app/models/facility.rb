# frozen_string_literal: true

class Facility < ApplicationRecord
  self.table_name = 'Facility'

  has_many :facility_requirements, dependent: :destroy, class_name: 'FacilityRequirement'
  has_many :documents, through: :facility_requirements

  has_many :shifts, dependent: :destroy, class_name: 'Shift'

  validates :name, presence: true
  validates :is_active, inclusion: { in: [true, false] }
end
