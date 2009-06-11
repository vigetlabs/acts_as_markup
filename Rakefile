# Look in the tasks/setup.rb file for the various options that can be
# configured in this Rakefile. The .rake files in the tasks directory
# are where the options are used.

load 'tasks/setup.rb'

ensure_in_path 'lib'
require 'acts_as_markup'

task :default => 'test:run'

PROJ.name = 'acts_as_markup'
PROJ.authors = 'Brian Landau'
PROJ.email = 'brian.landau@viget.com'
PROJ.url = 'http://viget.rubyforge.com/acts_as_markup'
PROJ.description = "Represent ActiveRecord Markdown, Textile, Wiki text, RDoc columns as Markdown, Textile Wikitext, RDoc objects using various external libraries to convert to HTML."
PROJ.rubyforge.name = 'viget'
PROJ.version = ActsAsMarkup::VERSION
PROJ.rdoc.include = %w(^lib/ LICENSE CHANGELOG README\.rdoc)
PROJ.rdoc.remote_dir = 'acts_as_markup'
PROJ.rcov.opts = ['--no-html', '-T', '--sort coverage',
                  '-x "\/Library\/Ruby\/"', 
                  '-x "\/opt\/local\/lib/ruby"',
                  '-x "\/System\/Library\/"']
PROJ.rcov.pattern = 'test/**/*_test.rb'

PROJ.gem.development_dependencies << ['thoughtbot-shoulda', '~> 2.0']
PROJ.gem.development_dependencies << ['bones', '~> 2.5']
depend_on 'activesupport', '~> 2.3.2'
depend_on 'activerecord', '~> 2.3.2'
depend_on 'rdiscount', '~> 1.3'
depend_on 'wikitext', '~> 1.5'
depend_on 'RedCloth', '~> 4.2'
