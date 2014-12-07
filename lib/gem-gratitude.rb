require 'rubygems'
require 'httparty'
require 'json'
require 'erb'
require 'redcarpet'

class Issue
  def self.list
    # Initializes a Markdown parser
    @markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true, hard_wrap: true, fenced_code_blocks: true)

    # Load Gemfile
    gemfile_path="#{Dir.pwd}/Gemfile"

    if !File.exist?(gemfile_path)
      puts "Couldn't find a Gemfile in this directory"
      exit
    end

    # List of all gems
    @gem_list = []

    # Characters to remove to get the pure gem name
    replacements = [ '\'', '"', ',' ]

    # Parse the gem names from the Gemfile
    puts 'Reading Gemfile...'
    File.open(gemfile_path).read.each_line do |line|
      parts = line.split
      if parts[0] == "gem" && parts[0].start_with?("gem")
        gem_name = parts[1]
        replacements.each {|r| gem_name.gsub!(r, '')}
        next if parts[2] == 'github:'
        begin
          gem_spec = Gem::Specification.find_by_name(gem_name)
          puts "#{gem_name}"
          @gem_list << {name: gem_name, homepage: gem_spec.homepage} if gem_spec.homepage
        rescue Gem::LoadError
          puts "Could not find gem '#{gem_name}'"
          next
        end
      end
    end

    # Not every gem_spec.homepage is a GitHub repo; try and find a GitHub link
    # Maybe via the GitHub Search API
    @gem_list.each do
      # if !(g[:homepage] =~ /https:\/\/github.com\//)
    end

    # Open HTML output file for writing
    tmp_html = '/tmp/giveback.html'
    file = File.open(tmp_html, 'w')

    # Find all open issues via the GitHub API
    puts 'Querying GitHub API for open issues...'
    @html_content = ''
    @issue_count = 0
    @gem_list.each do |g|
      github_url = g[:homepage].split('/')
      response = HTTParty.get("https://api.github.com/repos/#{github_url[-2]}/#{github_url[-1]}/issues?state=open")
      json = JSON.parse(response.body)
      if response.code == 200
        puts "#{g[:name]}: #{g[:homepage]} - #{json.count} open issues"
        json.each do |issue|
          @issue_count += 1
          @html_content <<
            "<h3>[#{g[:name]}] #{issue['title']}</h3>"\
            "<div><a class='github_link' href=\"#{issue['html_url']}\">View on GitHub: #{issue['title']}</a>"\
            "#{@markdown.render(issue['body'])}</div>"
        end
      end
    end

    # Write to ERB template
    puts 'Generating HTML...'
    erb = ERB.new(File.read('template.erb'))
    file.write erb.result(binding)

    # Open up the resulting HTML file
    `open #{tmp_html}`
  end
end
