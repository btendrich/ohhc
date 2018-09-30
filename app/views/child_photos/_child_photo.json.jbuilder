json.extract! child_photo, :id, :child_id, :description, :key, :row_order, :created_at, :updated_at
json.url child_photo_url(child_photo, format: :json)
