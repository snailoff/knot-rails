json.array!(@knots) do |knot|
  json.extract! knot, :id, :name, :content
  json.url knot_url(knot, format: :json)
end
