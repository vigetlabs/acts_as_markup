# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{acts_as_markup}
  s.version = "1.3.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Brian Landau"]
  s.date = %q{2009-06-11}
  s.description = %q{Represent ActiveRecord Markdown, Textile, Wiki text, RDoc columns as Markdown, Textile Wikitext, RDoc objects using various external libraries to convert to HTML.}
  s.email = %q{brian.landau@viget.com}
  s.extra_rdoc_files = ["CHANGELOG", "LICENSE", "README.rdoc"]
  s.files = ["CHANGELOG", "LICENSE", "README.rdoc", "Rakefile", "acts_as_markup.gemspec", "lib/acts/as_markup.rb", "lib/acts_as_markup.rb", "lib/acts_as_markup/exts/maruku.rb", "lib/acts_as_markup/exts/object.rb", "lib/acts_as_markup/exts/peg_markdown.rb", "lib/acts_as_markup/exts/rdiscount.rb", "lib/acts_as_markup/exts/rdoc.rb", "lib/acts_as_markup/exts/wikitext.rb", "lib/acts_as_markup/stringlike.rb", "tasks/bones.rake", "tasks/gem.rake", "tasks/git.rake", "tasks/post_load.rake", "tasks/rdoc.rake", "tasks/rubyforge.rake", "tasks/setup.rb", "tasks/test.rake", "test/acts_as_markdown_test.rb", "test/acts_as_markup_test.rb", "test/acts_as_rdoc_test.rb", "test/acts_as_textile_test.rb", "test/acts_as_wikitext_test.rb", "test/test_helper.rb"]
  s.homepage = %q{http://viget.rubyforge.com/acts_as_markup}
  s.rdoc_options = ["--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{viget}
  s.rubygems_version = %q{1.3.4}
  s.summary = %q{Represent ActiveRecord Markdown, Textile, Wiki text, RDoc columns as Markdown, Textile Wikitext, RDoc objects using various external libraries to convert to HTML}
  s.test_files = ["test/acts_as_markdown_test.rb", "test/acts_as_markup_test.rb", "test/acts_as_rdoc_test.rb", "test/acts_as_textile_test.rb", "test/acts_as_wikitext_test.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<activesupport>, ["~> 2.3.2"])
      s.add_runtime_dependency(%q<activerecord>, ["~> 2.3.2"])
      s.add_runtime_dependency(%q<rdiscount>, ["~> 1.3"])
      s.add_runtime_dependency(%q<wikitext>, ["~> 1.5"])
      s.add_runtime_dependency(%q<RedCloth>, ["~> 4.2"])
      s.add_development_dependency(%q<thoughtbot-shoulda>, ["~> 2.0"])
      s.add_development_dependency(%q<bones>, ["~> 2.5"])
    else
      s.add_dependency(%q<activesupport>, ["~> 2.3.2"])
      s.add_dependency(%q<activerecord>, ["~> 2.3.2"])
      s.add_dependency(%q<rdiscount>, ["~> 1.3"])
      s.add_dependency(%q<wikitext>, ["~> 1.5"])
      s.add_dependency(%q<RedCloth>, ["~> 4.2"])
      s.add_dependency(%q<thoughtbot-shoulda>, ["~> 2.0"])
      s.add_dependency(%q<bones>, ["~> 2.5"])
    end
  else
    s.add_dependency(%q<activesupport>, ["~> 2.3.2"])
    s.add_dependency(%q<activerecord>, ["~> 2.3.2"])
    s.add_dependency(%q<rdiscount>, ["~> 1.3"])
    s.add_dependency(%q<wikitext>, ["~> 1.5"])
    s.add_dependency(%q<RedCloth>, ["~> 4.2"])
    s.add_dependency(%q<thoughtbot-shoulda>, ["~> 2.0"])
    s.add_dependency(%q<bones>, ["~> 2.5"])
  end
end
