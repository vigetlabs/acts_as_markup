require 'active_support'

module ActsAsMarkup
  # :stopdoc:
  VERSION = '0.1.0'
  LIBPATH = ::File.expand_path(::File.dirname(__FILE__)) + ::File::SEPARATOR
  PATH = ::File.dirname(LIBPATH) + ::File::SEPARATOR
  # :startdoc:
  
  # This exception is raised when an unsupported markup language is supplied to acts_as_markup.
  class UnsportedMarkupLanguage < ArgumentError
  end
  
  DEFAULT_MAKRDOWN_LIB = :rdiscount
  
  MARKDOWN_LIBS = { :rdiscount => {:class_name => "RDiscount",
                                   :lib_name   => "rdiscount"}, 
                    :bluecloth => {:class_name => "BlueCloth",
                                   :lib_name   => "bluecloth"},
                    :rpeg      => {:class_name => "PEGMarkdown",
                                   :lib_name   => "peg_markdown"} }
  
  @@markdown_library = DEFAULT_MAKRDOWN_LIB
  mattr_accessor :markdown_library
  
  # :stopdoc:
  # Returns the version string for the library.
  #
  def self.version
    VERSION
  end

  # Returns the library path for the module. If any arguments are given,
  # they will be joined to the end of the libray path using
  # <tt>File.join</tt>.
  #
  def self.libpath( *args )
    args.empty? ? LIBPATH : ::File.join(LIBPATH, *args)
  end

  # Returns the lpath for the module. If any arguments are given,
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

ActsAsMarkup.require_all_libs_relative_to __FILE__
ActsAsMarkup.require_all_libs_relative_to __FILE__, 'acts'
