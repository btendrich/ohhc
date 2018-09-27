json.extract! child, :id, :name, :country, :size, :age_range, :gender, :description, :notes, :created_at, :updated_at
json.url child_url(child, format: :json)
