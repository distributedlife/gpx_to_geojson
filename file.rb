def write_geojson_file filename, coordinates
	trackfile = File.open(filename, "w")
	trackfile.write "{\"type\":\"LineString\", \"coordinates\": #{coordinates} }"
	trackfile.close
end