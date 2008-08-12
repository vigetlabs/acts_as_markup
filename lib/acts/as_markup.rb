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
          when :markdown
            klass = get_markdown_class
          when :textile
            require 'redcloth'
            klass = 'RedCloth'
          when :wikitext
            require 'wikitext'
            require_extensions 'wikitext'
            klass = 'WikitextString'
          when :rdoc
            require 'rdoc/markup/simple_markup'
            require 'rdoc/markup/simple_markup/to_html'
            require_extensions 'rdoc'
            klass = 'RDocText'
          when :variable
            markdown_klass = get_markdown_class
            require 'redcloth'
            require 'wikitext'
            require 'rdoc/markup/simple_markup'
            require 'rdoc/markup/simple_markup/to_html'
            require_extensions 'wikitext'
            require_extensions 'rdoc'
            textile_klass = 'RedCloth'
            wiki_klass = 'WikitextString'
            rdoc_klass = 'RDocText'
            options[:language_column] ||= :markup_language
          else
            raise ActsAsMarkup::UnsportedMarkupLanguage, "#{options[:langauge]} is not a currently supported markup language."
          end
          
          options[:columns].each do |col|
            unless options[:language].to_sym == :variable
              class_eval <<-EOV
                def #{col.to_s}
                  if @#{col.to_s}
                    unless self.#{col.to_s}_changed?
                      return @#{col.to_s}
                    end
                  end
                  @#{col.to_s} = #{klass}.new(self['#{col.to_s}'].to_s)
                end
              EOV
            else
              class_eval <<-EOV
                def #{col.to_s}
                  if @#{col.to_s}
                    unless self.#{col.to_s}_changed? || self.#{options[:language_column].to_s}_changed?
                      return @#{col.to_s}
                    end
                  end
                  case self.#{options[:language_column].to_s}
                  when /markdown/i
                    @#{col.to_s} = #{markdown_klass}.new(self['#{col.to_s}'].to_s)
                  when /textile/i
                    @#{col.to_s} = #{textile_klass}.new(self['#{col.to_s}'].to_s)
                  when /wikitext/i
                    @#{col.to_s} = #{wiki_klass}.new(self['#{col.to_s}'].to_s)
                  when /rdoc/i
                    @#{col.to_s} = #{rdoc_klass}.new(self['#{col.to_s}'].to_s)
                  else
                    @#{col.to_s} = self['#{col.to_s}']
                  end
                end
              EOV
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
              return markdown_library_names[:class_name]
            else
              raise ActsAsMarkup::UnsportedMarkdownLibrary, "#{ActsAsMarkup.markdown_library} is not currently supported."
            end
          end
          
          def require_extensions(library)# :nodoc:
            if %w(rdiscount maruku wikitext rdoc).include? library.to_s
              require "acts_as_markup/exts/#{library.to_s}"
            end
          end
        
      end
    end
  end
end

ActiveRecord::Base.send :include, ActiveRecord::Acts::AsMarkup
