require 'JSON'
require 'geo-distance'

def before file, long, lat
	points = []

	marker = [long, lat].geo_point

	json = JSON.parse(File.read(file))
	json['coordinates'].each do |point|
		metres = GeoDistance::Haversine.geo_distance(marker, point.geo_point).to_meters
		if metres < 100
			points << [long, lat]
			return points
		end

		points << point
	end

	points
end

puts "{\"type\":\"LineString\", \"coordinates\": #{before(ARGV[0], ARGV[1].to_f, ARGV[2].to_f)} }"