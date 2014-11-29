require 'rubygems'
require 'httparty'
require 'json'
require 'erb'

# Load Gemfile
gemfile_path=File.expand_path('../Gemfile', __FILE__)

# List of all gems
@gem_list = []

# Characters to remove to get the pure gem name
replacements = [ '\'', '"', ',' ]

# Parse the gem names from the Gemfile
File.open(gemfile_path).read.each_line do |line|
	parts = line.split
	if parts[0] == "gem" && parts[0].start_with?("gem")
		gem_name = parts[1]
		replacements.each {|r| gem_name.gsub!(r, '')}
		next if parts[2] == 'github:'
    gem_spec = Gem::Specification.find_by_name(gem_name)
	 	@gem_list << {name: gem_name, homepage: gem_spec.homepage}
	end
end

# Not every gem_spec.homepage is a GitHub repo; try and find a GitHub link
@gem_list.each do
	# if g[:homepage] =~ /https:\/\/github.com\//
end

# HTML file
file = File.open('giveback.html', 'w')

# Find all open issues via the GitHub API
@html_content = ''
@issue_count = 0
@gem_list[0..5].each do |g|
	github_url = g[:homepage].split('/')
	response = HTTParty.get("https://api.github.com/repos/#{github_url[-2]}/#{github_url[-1]}/issues?state=open")
	json = JSON.parse(response.body)
	if response.code == 200
		puts "#{g[:name]}: #{g[:homepage]} - #{json.count} open issues!"
		json.each do |issue|
			@issue_count += 1
			@html_content << "<h3>#{g[:name]}: <a href=\"#{issue['html_url']}\">#{issue['title']}</a></h3><div>#{issue['body'].gsub!(/(?:\n\r?|\r\n?)/, '<br>')}</div></h3>"
		end
	end
end

erb = ERB.new(File.read('template.erb'))
file.write erb.result(binding)
