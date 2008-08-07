require 'active_record'

module ActiveRecord # :nodoc:
  module Acts # :nodoc:
    module AsMarkup
      def self.included(base) # :nodoc:
        base.extend(ClassMethods)
      end
      
      module ClassMethods
        
        ##
        # This allows you to specify columns you want to define as containing 
        # Markdown or Textile content.
        # Then you can simply call <tt>.to_html</tt> method on the attribute.
        # 
        # You can also specify the language as <tt>:variable</tt> you will then
        # need to add an additional option of <tt>:language_column</tt>. When 
        # a value is accessed it will create the correct object (Markdown or Textile)
        # based on the value of the language column. If any value besides markdown or
        # textile is supplied for the markup language the text will pass through
        # as a string.
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
        #       acts_as_markup :language => :variable, :columns => [:body], :language_column => 'markup_language'
        #     end
        #     
        #     @post = Post.find(:first)
        #     @post.markup_language      # => "markdown"
        #     @post.body.to_s            # => "## Markdown Headline"
        #     @post.body.to_html         # => "<h2> Markdown Headline</h2>"
        #     
        # 
        def acts_as_markup(options)
          case options[:language].to_sym
          when :markdown
            if ActsAsMarkup::MARKDOWN_LIBS.keys.include? ActsAsMarkup.markdown_library
              markdown_library_names = ActsAsMarkup::MARKDOWN_LIBS[ActsAsMarkup.markdown_library]
              require markdown_library_names[:lib_name]
              klass = markdown_library_names[:class_name]
            else
              raise ActsAsMarkup::UnsportedMarkdownLibrary, "#{ActsAsMarkup.markdown_library} is not currently supported."
            end
          when :textile
            require 'redcloth'
            klass = 'RedCloth'
          when :variable
            if ActsAsMarkup::MARKDOWN_LIBS.keys.include? ActsAsMarkup.markdown_library
              markdown_library_names = ActsAsMarkup::MARKDOWN_LIBS[ActsAsMarkup.markdown_library]
              require markdown_library_names[:lib_name]
              markdown_klass = markdown_library_names[:class_name]
            else
              raise ActsAsMarkup::UnsportedMarkdownLibrary, "#{ActsAsMarkup.markdown_library} is not currently supported."
            end
            require 'redcloth'
            textile_klass = 'RedCloth'
          else
            raise ActsAsMarkup::UnsportedMarkupLanguage, "#{options[:langauge]} is not a currently supported markup language."
          end
          
          options[:columns].each do |col|
            unless options[:language].to_sym == :variable
              class_eval <<-EOV
                def #{col.to_s}
                  if @#{col.to_s}
                    if !self.#{col.to_s}_changed?
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
                  else
                    @#{col.to_s} = self['#{col.to_s}']
                  end
                end
              EOV
            end
          end
        end
        
        ##
        # This is a convenience method for 
        # `<tt>acts_as_markup :language => :markdown, :columns => [:body]</tt>`
        # 
        def acts_as_markdown(*columns)
          acts_as_markup :language => :markdown, :columns => columns
        end
        
        ##
        # This is a convenience method for 
        # `<tt>acts_as_markup :language => :textile, :columns => [:body]</tt>`
        #
        def acts_as_textile(*columns)
          acts_as_markup :language => :textile, :columns => columns
        end
        
      end
    end
  end
end

ActiveRecord::Base.send :include, ActiveRecord::Acts::AsMarkup
