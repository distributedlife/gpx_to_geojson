require 'JSON'

first = ARGV[0]
second = ARGV[1]

def get_json filename
	JSON.parse(File.read(filename))
end

def get_coordinates json
	unless json['coordinates'].nil?
		return json['coordinates']
	end

	coordinates = []
	json['features'].each do |feature|
		coordinates = coordinates + feature['geometry']['coordinates']
	end

	coordinates
end


def merge_points first, second
	points = []

	get_coordinates(get_json(first)).each do |point|
		points << point
	end
	get_coordinates(get_json(second)).each do |point|
		points << point
	end

	points
end


puts "{\"type\":\"LineString\", \"coordinates\": #{merge_points(first, second)} }"