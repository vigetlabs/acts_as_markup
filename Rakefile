# Look in the tasks/setup.rb file for the various options that can be
# configured in this Rakefile. The .rake files in the tasks directory
# are where the options are used.
$:.unshift(File.expand_path('lib'))

require 'rake'
require 'acts_as_markup'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "acts_as_markup"
    gem.summary = %Q{Represent ActiveRecord Markdown, Textile, Wiki text, RDoc columns as Markdown, Textile Wikitext, RDoc objects using various external libraries to convert to HTML.}
    gem.description = %Q{Represent ActiveRecord Markdown, Textile, Wiki text, RDoc columns as Markdown, Textile Wikitext, RDoc objects using various external libraries to convert to HTML.}
    gem.email = "brian.landau@viget.com"
    gem.homepage = "http://vigetlabs.github.com/acts_as_markup/"
    gem.authors = ["Brian Landau"]
    gem.version = ActsAsMarkup::VERSION
    gem.add_dependency('activesupport', '>= 2.3.2')
    gem.add_dependency('activerecord', '>= 2.3.2')
    gem.add_dependency('rdiscount', '~> 1.3')
    gem.add_dependency('wikitext', '~> 2.0')
    gem.add_dependency('RedCloth', '~> 4.2')
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
end

require 'tasks/test'
require 'tasks/rdoc'

task :test => :check_dependencies
task :default => :test
