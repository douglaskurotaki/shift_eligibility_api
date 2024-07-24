# frozen_string_literal: true

json.set! :shifts do
  json.array! @shifts, partial: 'api/v1/shifts/shift', as: :shift
end

json.pagination pagination_meta(@shifts)
