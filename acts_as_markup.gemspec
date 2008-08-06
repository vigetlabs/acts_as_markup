Gem::Specification.new do |s|
  s.name = %q{acts_as_markdown}
  s.version = "0.1.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Brian Landau"]
  s.date = %q{2008-08-06}
  s.description = %q{Represent ActiveRecord markdown text columns as Markdown objects using various external libraries to convert to HTML.}
  s.email = %q{brian.landau@viget.com}
  s.extra_rdoc_files = ["LICENSE.txt", "README.rdoc"]
  s.files = ["History.txt", "LICENSE.txt", "Manifest.txt", "README.rdoc", "Rakefile", "acts_as_markdown.gemspec", "lib/acts/as_markdown.rb", "lib/acts_as_markdown.rb", "lib/acts_as_markdown/exts/rdiscount.rb", "tasks/bones.rake", "tasks/gem.rake", "tasks/git.rake", "tasks/manifest.rake", "tasks/post_load.rake", "tasks/rdoc.rake", "tasks/rubyforge.rake", "tasks/setup.rb", "tasks/test.rake", "test/acts_as_markdown_test.rb", "test/test_helper.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://viget.rubyforge.com/acts_as_markdown}
  s.rdoc_options = ["--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{viget}
  s.rubygems_version = %q{1.2.0}
  s.summary = %q{Represent ActiveRecord markdown text columns as Markdown objects using various external libraries to convert to HTML}
  s.test_files = ["test/acts_as_markdown_test.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if current_version >= 3 then
      s.add_runtime_dependency(%q<activesupport>, [">= 2.1.0"])
      s.add_runtime_dependency(%q<activerecord>, [">= 2.1.0"])
      s.add_runtime_dependency(%q<rdiscount>, [">= 1.2.7"])
    else
      s.add_dependency(%q<activesupport>, [">= 2.1.0"])
      s.add_dependency(%q<activerecord>, [">= 2.1.0"])
      s.add_dependency(%q<rdiscount>, [">= 1.2.7"])
    end
  else
    s.add_dependency(%q<activesupport>, [">= 2.1.0"])
    s.add_dependency(%q<activerecord>, [">= 2.1.0"])
    s.add_dependency(%q<rdiscount>, [">= 1.2.7"])
  end
end
