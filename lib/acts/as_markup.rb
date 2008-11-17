require 'active_record'

module ActiveRecord # :nodoc:
  module Acts # :nodoc:
    module AsMarkup
      def self.included(base) # :nodoc:
        base.extend(ClassMethods)
      end
      
      module ClassMethods
        
        # This allows you to specify columns you want to define as containing 
        # Markdown, Textile, Wikitext or RDoc content.
        # Then you can simply call <tt>.to_html</tt> method on the attribute.
        # 
        # You can also specify the language as <tt>:variable</tt>. The language used
        # to process the column will be based on another column. By default a column
        # named "<tt>markup_language</tt>" is used, but this can be changed by providing 
        # a <tt>:language_column</tt> option. When a value is accessed it will create 
        # the correct object (Markdown, Textile, Wikitext or RDoc) based on the value 
        # of the language column. If any value besides markdown, textile, wikitext, or 
        # RDoc is supplied for the markup language the text will pass through as a string.
        # 
        # 
        # ==== Examples
        # 
        # ===== Using Markdown language
        # 
        #     class Post < ActiveRecrod
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
        #     class Post < ActiveRecrod
        #       acts_as_markup :language => :variable, :columns => [:body], :language_column => 'language_name'
        #     end
        #     
        #     @post = Post.find(:first)
        #     @post.language_name        # => "markdown"
        #     @post.body.to_s            # => "## Markdown Headline"
        #     @post.body.to_html         # => "<h2> Markdown Headline</h2>"
        #     
        # 
        def acts_as_markup(options)
          case options[:language].to_sym
          when :markdown, :textile, :wikitext, :rdoc
            klass = require_library_and_get_class(options[:language].to_sym)
          when :variable
            markup_klasses = {}
            [:textile, :wikitext, :rdoc, :markdown].each do |language|
              markup_klasses[language] = require_library_and_get_class(language)
            end
            options[:language_column] ||= :markup_language
          else
            raise ActsAsMarkup::UnsupportedMarkupLanguage, "#{options[:langauge]} is not a currently supported markup language."
          end
          
          options[:columns].each do |col|
            unless options[:language].to_sym == :variable
              define_method col do
                if iv = instance_variable_get("@#{col}")
                  unless send("#{col}_changed?")
                    return iv
                  end
                end
                instance_variable_set("@#{col}", klass.new(self[col].to_s))
              end
            else
              define_method col do
                if iv = instance_variable_get("@#{col}")
                  unless send("#{col}_changed?") || send("#{options[:language_column]}_changed?")
                    return iv
                  end
                end
                instance_variable_set("@#{col}", case send(options[:language_column])
                when /markdown/i
                  markup_klasses[:markdown].new(self[col].to_s)
                when /textile/i
                  markup_klasses[:textile].new(self[col].to_s)
                when /wikitext/i
                  markup_klasses[:wikitext].new(self[col].to_s)
                when /rdoc/i
                  markup_klasses[:rdoc].new(self[col].to_s)
                else
                  self[col]
                end)
              end
            end
          end
        end
        
        # This is a convenience method for 
        # `<tt>acts_as_markup :language => :markdown, :columns => [:body]</tt>`
        # 
        def acts_as_markdown(*columns)
          acts_as_markup :language => :markdown, :columns => columns
        end
        
        # This is a convenience method for 
        # `<tt>acts_as_markup :language => :textile, :columns => [:body]</tt>`
        #
        def acts_as_textile(*columns)
          acts_as_markup :language => :textile, :columns => columns
        end
        
        # This is a convenience method for 
        # `<tt>acts_as_markup :language => :wikitext, :columns => [:body]</tt>`
        #
        def acts_as_wikitext(*columns)
          acts_as_markup :language => :wikitext, :columns => columns
        end
        
        # This is a convenience method for 
        # `<tt>acts_as_markup :language => :rdoc, :columns => [:body]</tt>`
        #
        def acts_as_rdoc(*columns)
          acts_as_markup :language => :rdoc, :columns => columns
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
              require "acts_as_markup/exts/#{library.to_s}"
            end
          end
          
          def require_library_and_get_class(language)
            case language
            when :markdown
              return get_markdown_class
            when :textile
              require 'redcloth'
              return RedCloth
            when :wikitext
              require 'wikitext'
              require_extensions 'wikitext'
              return WikitextString
            when :rdoc
              require 'rdoc/markup/simple_markup'
              require 'rdoc/markup/simple_markup/to_html'
              require_extensions 'rdoc'
              return RDocText
            else
              return String
            end
          end
        
      end
    end
  end
end

ActiveRecord::Base.send :include, ActiveRecord::Acts::AsMarkup
