json.array!(@categories) do |category|
  json.extract! category, :id, :title, :description
  json.url category_url(category, format: :json)
end
