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
  class << self
    def version
      VERSION
    end

    def markup_class(markup_name)
      load_markup_class(markup_name)
    end
    
    private

    def get_markdown_class
      if ActsAsMarkup::MARKDOWN_LIBS.keys.include? ActsAsMarkup.markdown_library
        markdown_library_names = ActsAsMarkup::MARKDOWN_LIBS[ActsAsMarkup.markdown_library]
        require markdown_library_names[:lib_name]
        require_extensions(markdown_library_names[:lib_name])
        return markdown_library_names[:class_name].constantize
      else
        raise ActsAsMarkup::UnsportedMarkdownLibrary, "#{ActsAsMarkup.markdown_library} is not currently supported."
      end
    end
    
    def require_extensions(library)# :nodoc:
      if ActsAsMarkup::LIBRARY_EXTENSIONS.include? library.to_s
        require "acts_as_markup/exts/#{library}"
      end
    end
    
    def require_library_and_get_class(language)
      case language
      when :markdown
        return get_markdown_class
      when :textile
        require 'redcloth'
        return RedCloth
      when :rdoc
        require 'rdoc'
        require_extensions 'rdoc'
        return RDocText
      else
        return String
      end
    end
    
    def load_markup_class(markup_name)
      if [:markdown, :textile, :rdoc].include?(markup_name.to_sym)
        require_library_and_get_class(markup_name.to_sym)
      else
        raise ActsAsMarkup::UnsupportedMarkupLanguage, "#{markup_name} is not a currently supported markup language."
      end
    end
  end

end

ActiveSupport.run_load_hooks(:acts_as_markup, ActsAsMarkup)
