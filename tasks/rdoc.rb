require 'rake/sdoctask'
require 'sdoc_helpers/pages'

Rake::SDocTask.new do |rdoc|
  version = ActsAsMarkup::VERSION
  rdoc.title = "ActsAsMarkup #{version} Documentation"
  rdoc.rdoc_files.include('lib/**/*.rb')
end
