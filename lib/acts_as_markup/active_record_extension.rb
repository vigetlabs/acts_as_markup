module ActsAsMarkup
  module ActiveRecordExtension
    extend ActiveSupport::Concern

    def string_for_markup_column(column_name)
      self[column_name].to_s
    end

    module ClassMethods
      
      # This allows you to specify columns you want to define as containing 
      # Markdown, Textile, or RDoc content.
      # Then you can simply call <tt>.to_html</tt> method on the attribute.
      # 
      # You can also specify the language as <tt>:variable</tt>. The language used
      # to process the column will be based on another column. By default a column
      # named "<tt>markup_language</tt>" is used, but this can be changed by providing 
      # a <tt>:language_column</tt> option. When a value is accessed it will create 
      # the correct object (Markdown, Textile, or RDoc) based on the value 
      # of the language column. If any value besides markdown, textile, or 
      # RDoc is supplied for the markup language the text will pass through as a string.
      #
      # You can specify additional options to pass to the markup library by using
      # <tt>:markdown_options</tt>, <tt>:textile_options</tt> .
      # RDoc does not support any useful options. The options should be given as an array
      # of arguments. You can specify options for more than one language when using
      # <tt>:variable</tt>. See each library's documentation for more details on what
      # options are available.
      # 
      # 
      # ==== Examples
      # 
      # ===== Using Markdown language
      # 
      #     class Post < ActiveRecord
      #       acts_as_markup :language => :markdown, :columns => [:body]
      #     end
      #     
      #     @post = Post.find(:first)
      #     @post.body.to_s            # => "## Markdown Headline"
      #     @post.body.to_html         # => "<h2> Markdown Headline</h2>"
      #     
      # 
      # ===== Using variable language
      # 
      #     class Post < ActiveRecord
      #       acts_as_markup :language => :variable, :columns => [:body], :language_column => 'language_name'
      #     end
      #     
      #     @post = Post.find(:first)
      #     @post.language_name        # => "markdown"
      #     @post.body.to_s            # => "## Markdown Headline"
      #     @post.body.to_html         # => "<h2> Markdown Headline</h2>"
      #     
      # 
      # ===== Using options
      # 
      #     class Post < ActiveRecord
      #       acts_as_markup :language => :markdown, :columns => [:body], :markdown_options => [ :filter_html ]
      #     end
      #     
      #     class Post < ActiveRecord
      #       acts_as_markup :language => :textile, :columns => [:body], :textile_options => [ [ :filter_html ] ]
      #     end
      #     
      # 
      def acts_as_markup(options)
        options.reverse_merge!(:language_column => :markup_language)
        markup_class = load_markup_class(options)
        
        unless options[:language].to_sym == :variable
          define_markup_columns_reader_methods(markup_class, options)
        else
          define_variable_markup_columns_reader_methods(markup_class, options)
        end
      end
      
      # This is a convenience method for 
      # `<tt>acts_as_markup :language => :markdown, :columns => [:body]</tt>`
      # Additional options can be given at the end, if necessary.
      # 
      def acts_as_markdown(*columns)
        options = columns.extract_options!
        acts_as_markup options.merge(:language => :markdown, :columns => columns)
      end
      
      # This is a convenience method for 
      # `<tt>acts_as_markup :language => :textile, :columns => [:body]</tt>`
      # Additional options can be given at the end, if necessary.
      #
      def acts_as_textile(*columns)
        options = columns.extract_options!
        acts_as_markup options.merge(:language => :textile, :columns => columns)
      end
      
      # This is a convenience method for 
      # `<tt>acts_as_markup :language => :rdoc, :columns => [:body]</tt>`
      # Additional options can be given at the end, if necessary.
      #
      def acts_as_rdoc(*columns)
        options = columns.extract_options!
        acts_as_markup options.merge(:language => :rdoc, :columns => columns)
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
        
        def load_markup_class(options)
          case options[:language].to_sym
          when :markdown, :textile, :rdoc
            require_library_and_get_class(options[:language].to_sym)
          when :variable
            markup_classes = {}
            [:textile, :rdoc, :markdown].each do |language|
              markup_classes[language] = require_library_and_get_class(language)
            end
            markup_classes
          else
            raise ActsAsMarkup::UnsupportedMarkupLanguage, "#{options[:langauge]} is not a currently supported markup language."
          end
        end
        
        def define_markup_columns_reader_methods(markup_class, options)
          markup_options = options["#{options[:language]}_options".to_sym] || []
          
          options[:columns].each do |col|
            define_method col do
              if instance_variable_defined?("@#{col}") && !send("#{col}_changed?")
                  instance_variable_get("@#{col}")
              else
                instance_variable_set("@#{col}", markup_class.new(self[col].to_s, *markup_options))
              end
            end
          end
        end

        def define_variable_markup_columns_reader_methods(markup_classes, options)
          options[:columns].each do |col|
            define_method col do
              if instance_variable_defined?("@#{col}")
                unless send("#{col}_changed?") || send("#{options[:language_column]}_changed?")
                  return instance_variable_get("@#{col}")
                end
              end
              instance_variable_set("@#{col}", case send(options[:language_column])
              when /markdown/i
                markup_classes[:markdown].new string_for_markup_column(col), *(options[:markdown_options] || [])
              when /textile/i
                markup_classes[:textile].new string_for_markup_column(col), *(options[:textile_options] || [])
              when /rdoc/i
                markup_classes[:rdoc].new string_for_markup_column(col)
              else
                self[col]
              end)
            end
          end
        end
      
    end
  end
end
