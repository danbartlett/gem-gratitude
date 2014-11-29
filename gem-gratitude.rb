# Load Gemfile
gemfile_path=File.expand_path('../Gemfile', __FILE__)

# List of all gems
gem_list = []

# Characters to remove to get the pure gem name
replacements = [ '\'', '"', ',' ]

File.open(gemfile_path).read.each_line do |line|
	parts = line.split
	# puts parts.inspect
	if parts[0] == "gem" && parts[0].start_with?("gem")
		cleaned = parts[1]
		replacements.each {|r| cleaned.gsub!(r, '')}
	 	gem_list.push cleaned
	end
end

gem_list.each {|g| puts g}

# TODO: Exclusion list
exclusion = ['rails']