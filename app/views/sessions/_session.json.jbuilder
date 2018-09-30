json.extract! session, :id, :name, :beings, :public, :created_at, :updated_at
json.url session_url(session, format: :json)
