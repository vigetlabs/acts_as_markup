require 'set'
require 'active_support'
require 'active_support/core_ext'

require 'acts_as_markup/version'
require 'acts_as_markup/railtie' if defined?(Rails)

module ActsAsMarkup
  # This exception is raised when an unsupported markup language is supplied to acts_as_markup.
  class UnsupportedMarkupLanguage < ArgumentError
  end
  
  # This exception is raised when an unsupported Markdown library is set to the config value.
  class UnsportedMarkdownLibrary < ArgumentError
  end
  
  MARKDOWN_LIBS = { :rdiscount => {:class_name => "RDiscount",
                                   :lib_name   => "rdiscount"}, 
                    :bluecloth => {:class_name => "BlueClothText",
                                   :lib_name   => "bluecloth"},
                    :rpeg      => {:class_name => "PEGMarkdown",
                                   :lib_name   => "peg_markdown"},
                    :maruku    => {:class_name => "Maruku",
                                   :lib_name   => "maruku"},
                    :redcarpet => {:class_name => "RedcarpetText",
                                   :lib_name   => 'redcarpet'} }
                                   
  LIBRARY_EXTENSIONS = ::Set.new(Dir[File.join(File.expand_path(File.dirname(__FILE__)), 'acts_as_markup/exts/*.rb')].map {|file| File.basename(file, '.rb')}).delete('string')

  mattr_accessor :markdown_library

  # Returns the version string for the library.
  def self.version
    VERSION
  end

end

ActiveSupport.run_load_hooks(:acts_as_markup, ActsAsMarkup)
