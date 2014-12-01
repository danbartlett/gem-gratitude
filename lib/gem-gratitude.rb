require 'rubygems'
require 'httparty'
require 'json'
require 'erb'
require 'redcarpet'

# Initializes a Markdown parser
@markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true, hard_wrap: true, fenced_code_blocks: true)

# Format the issue body
def summary(text)
  parsed = @markdown.render(text)
end

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

# Open HTML output file for writing
file = File.open('giveback.html', 'w')

# Find all open issues via the GitHub API
@html_content = ''
@issue_count = 0
@gem_list.each do |g|
  github_url = g[:homepage].split('/')
  response = HTTParty.get("https://api.github.com/repos/#{github_url[-2]}/#{github_url[-1]}/issues?state=open")
  json = JSON.parse(response.body)
  if response.code == 200
    puts "#{g[:name]}: #{g[:homepage]} - #{json.count} open issues!"
    json.each do |issue|
      @issue_count += 1
      @html_content <<
        "<h3>[#{g[:name]}] #{issue['title']}</h3>"\
        "<div><a class='github_link' href=\"#{issue['html_url']}\">View on GitHub: #{issue['title']}</a>"\
        "#{summary(issue['body'])}</div>"
    end
  end
end

# Write to ERB template
erb = ERB.new(File.read('template.erb'))
file.write erb.result(binding)
