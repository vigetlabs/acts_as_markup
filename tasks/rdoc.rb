begin
  gem 'brianjlandau-sdoc-helpers'
  require 'sdoc_helpers'
  require 'rake/sdoctask'
  
  Rake::SDocTask.new do |rdoc|
    version = ActsAsMarkup::VERSION
    rdoc.title = "ActsAsMarkup #{version} Documentation"
    rdoc.rdoc_files.include('lib/**/*.rb')
  end
rescue LoadError
  puts "sdoc RDoc tasks not loaded. Please intall sdoc."
end