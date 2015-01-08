require 'JSON'
require 'geo-distance'

def after file, long, lat
	points = []

	marker = [long, lat].geo_point
	found_marker = false

	json = JSON.parse(File.read(file))
	json['coordinates'].each do |point|
		metres = GeoDistance::Haversine.geo_distance(marker, point.geo_point).to_meters
		if metres < 100
			found_marker = true
			points << [long, lat]
			next
		end
		next unless found_marker

		points << point
	end

	points
end

puts "{\"type\":\"LineString\", \"coordinates\": #{after(ARGV[0], ARGV[1].to_f, ARGV[2].to_f)} }"