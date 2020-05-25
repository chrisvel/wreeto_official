json.array!(@tags) do |category|
  json.extract! tag, :id, :name
  json.url tag_url(tag, format: :json)
end
