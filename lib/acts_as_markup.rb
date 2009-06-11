require 'active_support'

module ActsAsMarkup
  # :stopdoc:
  VERSION = '1.3.3'.freeze
  LIBPATH = ::File.expand_path(::File.dirname(__FILE__)) + ::File::SEPARATOR
  PATH = ::File.dirname(LIBPATH) + ::File::SEPARATOR
  # :startdoc:
  
  # This exception is raised when an unsupported markup language is supplied to acts_as_markup.
  class UnsupportedMarkupLanguage < ArgumentError
  end
  
  # This exception is raised when an unsupported Markdown library is set to the config value.
  class UnsportedMarkdownLibrary < ArgumentError
  end
  
  DEFAULT_MARKDOWN_LIB = :rdiscount
  
  MARKDOWN_LIBS = { :rdiscount => {:class_name => "RDiscount",
                                   :lib_name   => "rdiscount"}, 
                    :bluecloth => {:class_name => "BlueCloth",
                                   :lib_name   => "bluecloth"},
                    :rpeg      => {:class_name => "PEGMarkdown",
                                   :lib_name   => "peg_markdown"},
                    :maruku    => {:class_name => "Maruku",
                                   :lib_name   => "maruku"} }
                                   
  LIBRARY_EXTENSIONS = Set.new(Dir[ActsAsMarkup::LIBPATH + 'acts_as_markup/exts/*.rb'].map {|file| File.basename(file, '.rb')}).delete('string')
  
  @@markdown_library = DEFAULT_MARKDOWN_LIB
  mattr_accessor :markdown_library
  
  # :stopdoc:
  # Returns the version string for the library.
  #
  def self.version
    VERSION
  end

  # Returns the library path for the module. If any arguments are given,
  # they will be joined to the end of the library path using
  # <tt>File.join</tt>.
  #
  def self.libpath( *args )
    args.empty? ? LIBPATH : ::File.join(LIBPATH, *args)
  end

  # Returns the path for the module. If any arguments are given,
  # they will be joined to the end of the path using
  # <tt>File.join</tt>.
  #
  def self.path( *args )
    args.empty? ? PATH : ::File.join(PATH, *args)
  end

  # Utility method used to rquire all files ending in .rb that lie in the
  # directory below this file that has the same name as the filename passed
  # in. Optionally, a specific _directory_ name can be passed in such that
  # the _filename_ does not have to be equivalent to the directory.
  #
  def self.require_all_libs_relative_to( fname, dir = nil )
    dir ||= ::File.basename(fname, '.*')
    search_me = ::File.expand_path(
        ::File.join(::File.dirname(fname), dir, '**', '*.rb'))

    Dir.glob(search_me).sort.each {|rb| require rb}
  end
  # :startdoc:

end  # module ActsAsMarkup

require 'acts_as_markup/exts/object'
require 'acts_as_markup/stringlike'
ActsAsMarkup.require_all_libs_relative_to __FILE__, 'acts'
