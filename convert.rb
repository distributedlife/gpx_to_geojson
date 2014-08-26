require 'nokogiri'
require 'geo-distance'
require "./file"

def points segments
	point_list = []
	last_geo_point = nil

	segments.each do |segment|
		points = segment.children.select {|child| child.name == "trkpt"}
		points.each do |point|
			long_lat = [ point.attribute('lon').to_s.to_f, point.attribute('lat').to_s.to_f ]
			geo_point = long_lat.geo_point
			if last_geo_point.nil?
				point_list << long_lat
				last_geo_point = geo_point
			else
				metres = GeoDistance::Haversine.geo_distance(last_geo_point, geo_point).to_meters
				next if metres < 100

				point_list << long_lat
				last_geo_point = geo_point
			end
		end
	end

	point_list
end

GeoPoint.coord_mode = :lng_lat
filename = ARGV[0]

document = Nokogiri::XML(File.read(filename))
gpx = document.children.first
tracks = gpx.children.select {|child| child.name == "trk" }
tracks.each do |track|
	name = track.children.select {|child| child.name == "name"}.first.text
	segments = track.children.select {|child| child.name == "trkseg"}
	next if segments.empty?
	next if points(segments).length == 1
	
	time = segments.first.children.select {|child| child.name == "trkpt"}.first.children.select {|child| child.name == "time"}.first.text

	puts "Creating track: #{name}"

	dirname = filename.gsub(".gpx", "")
	Dir.mkdir dirname unless Dir.exists? dirname

	write_geojson_file "#{dirname}/#{name}.geojson", points(segments)
end