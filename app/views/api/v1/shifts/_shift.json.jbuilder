# frozen_string_literal: true

json.extract! shift, :id, :start, :end, :is_deleted, :profession, :facility_id
json.facility do
  json.extract!(shift.facility, :id, :name, :is_active)
end
