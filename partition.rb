require 'JSON'
require 'geo-distance'
require "./file"

def partition file
	points = []

	last_geo_point = nil
	count = 0

	json = JSON.parse(File.read(file))
	json['coordinates'].each do |point|
		if last_geo_point.nil?
			points << point
			last_geo_point = point.geo_point
			next
		end

		metres = GeoDistance::Haversine.geo_distance(point.geo_pointet, last_geo_point).to_meters
		if metres >= 1000
			write_geojson_file "tracks/#{file}-#{count}.geojson", points
			
			points = []
			count = count + 1
		end

		points << point
	end

	write_geojson_file "tracks/#{file}-#{count}.geojson", points
end

partition ARGV[0]