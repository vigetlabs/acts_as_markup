begin
  require 'rake/rdoctask'
  gem 'brianjlandau-sdoc-helpers'
  require 'sdoc_helpers'
  
  Rake::RDocTask.new do |rdoc|
    version = ActsAsMarkup::VERSION

    rdoc.rdoc_dir = 'docs'
    rdoc.title = "ActsAsMarkup #{version} Documentation"
    rdoc.rdoc_files.include('README*')
    rdoc.rdoc_files.include('LICENSE')
    rdoc.rdoc_files.include('CHANGELOG')
    rdoc.rdoc_files.include('lib/**/*.rb')
    rdoc.main = 'README.rdoc'
    rdoc.template = 'direct'
    rdoc.options << '--fmt' << 'shtml'
  end
rescue LoadError
  puts "sdoc RDoc tasks not loaded. Please intall sdoc."
end