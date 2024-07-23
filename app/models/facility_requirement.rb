# frozen_string_literal: true

class FacilityRequirement < ApplicationRecord
  self.table_name = 'FacilityRequirement'

  belongs_to :facility, class_name: 'Facility'
  belongs_to :document, class_name: 'Document'
end
