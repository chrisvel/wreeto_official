json.extract! inquiry, :id, :reason, :body, :user_id, :created_at, :updated_at
json.url inquiry_url(inquiry, format: :json)
