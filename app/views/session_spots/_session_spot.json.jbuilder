json.extract! session_spot, :id, :child_id, :hosting_session_id, :status_id, :scholarship, :row_order, :public_notes, :private_notes, :created_at, :updated_at
json.url session_spot_url(session_spot, format: :json)
