# encoding: utf-8
require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'

$:.unshift(File.expand_path('lib'))
$:.unshift(File.expand_path(File.dirname(__FILE__)))
require 'acts_as_markup'

Jeweler::Tasks.new do |gem|
  gem.name = "acts_as_markup"
  gem.summary = %Q{Represent ActiveRecord Markdown, Textile, Wiki text, RDoc columns as Markdown, Textile Wikitext, RDoc objects using various external libraries to convert to HTML.}
  gem.description = %Q{Represent ActiveRecord Markdown, Textile, Wiki text, RDoc columns as Markdown, Textile Wikitext, RDoc objects using various external libraries to convert to HTML.}
  gem.email = "brian.landau@viget.com"
  gem.homepage = "http://vigetlabs.github.com/acts_as_markup/"
  gem.license = "MIT"
  gem.authors = ["Brian Landau"]
  gem.version = ActsAsMarkup::VERSION
  gem.add_dependency('activesupport', '>= 2.3.2')
  gem.add_dependency('activerecord', '>= 2.3.2')
  gem.add_dependency('rdiscount', '~> 1.3')
  gem.add_dependency('wikitext', '~> 2.0')
  gem.add_dependency('RedCloth', '~> 4.2')
  # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
end
Jeweler::RubygemsDotOrgTasks.new

require 'tasks/test'
require 'tasks/rdoc'

task :default => :test
