# frozen_string_literal: true

class DocumentWorker < ApplicationRecord
  self.table_name = 'DocumentWorker'

  belongs_to :worker, class_name: 'Worker'
  belongs_to :document, class_name: 'Document'
end
