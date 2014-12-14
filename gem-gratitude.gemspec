Gem::Specification.new do |s|
  s.name        = 'gem-gratitude'
  s.version     = '0.1.9'
  s.date        = '2014-12-01'
  s.summary     = "Show all open GitHub issues for gems you require in your projects"
  s.description = "Give back to gems you depend on! Show all open GitHub issues for gems you require in your projects"
  s.authors     = ["Dan Bartlett"]
  s.email       = 'danbartlett@gmail.com'
  s.files       = ["lib/gem-gratitude.rb", "bin/gem-gratitude", "template.erb"]
  s.executables << 'gem-gratitude'
  s.add_runtime_dependency "httparty"
  s.add_runtime_dependency "redcarpet"
  s.homepage    = 'http://rubygems.org/gems/gem-gratitude'
  s.license     = 'MIT'
end