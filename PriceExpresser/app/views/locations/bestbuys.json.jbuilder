json.array!(@bestbuys) do |location|
  json.extract! location, :id, :latitude, :longitude, :address, :description, :title
  json.url location_url(location, format: :json)
end