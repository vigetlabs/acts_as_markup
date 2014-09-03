$:.push File.expand_path("../lib", __FILE__)

require "acts_as_markup/version"

Gem::Specification.new do |s|
  s.name = "acts_as_markup"
  s.version = ActsAsMarkup::VERSION

  s.authors = ["Brian Landau"]
  s.description = "Represent ActiveRecord Markdown, Textile, RDoc columns as Markdown, Textile, RDoc objects using various external libraries to convert to HTML."
  s.email = "brian.landau@viget.com"
  s.extra_rdoc_files = [
    "LICENSE",
    "CHANGELOG",
    "README.rdoc"
  ]
  s.files = Dir["{app,config,db,lib}/**/*"] + ["LICENSE", "Rakefile", "README.rdoc", "CHANGELOG"]
  s.test_files = Dir["test/**/*"]

  s.homepage = "http://vigetlabs.github.com/acts_as_markup/"
  s.license = "MIT"
  s.require_paths = ["lib"]
  s.summary = "Represent ActiveRecord Markdown, Textile, RDoc columns as Markdown, Textile, RDoc objects using various external libraries to convert to HTML."

  s.add_dependency "activesupport", '>= 3.0.20'
  s.add_dependency "activerecord", '>= 3.0.20'
  s.add_dependency "rdiscount"

  s.add_development_dependency "appraisal"
  s.add_development_dependency "sqlite3-ruby"
  s.add_development_dependency "shoulda"
  s.add_development_dependency "sdoc"
  s.add_development_dependency "brianjlandau-sdoc-helpers"
  s.add_development_dependency "RedCloth"
  s.add_development_dependency "rdoc"
  s.add_development_dependency "bluecloth"
  s.add_development_dependency "maruku"
  s.add_development_dependency "rpeg-markdown"
  s.add_development_dependency "redcarpet"
end

