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
        # markdown or Textile content.
        # Then you can simply call +.to_html+ method on the attribute.
        #
        # === Example
        #     class Post < ActiveRecrod
        #       acts_as_markup :language => :markdown, :columns => [:body]
        #     end
        # 
        #     @post = Post.find(:first)
        #     @post.body.to_s     #=> "## Markdown Headline"
        #     @post.body.to_html  #=> "<h2> Markdown Headline</h2>"
        # 
        def acts_as_markup(options)
          case options[:language].to_sym
          when :markdown
            library_names = ::ActsAsMarkup::MARKDOWN_LIBS[ActsAsMarkup.markdown_library]
            require library_names[:lib_name]
            klass = library_names[:class_name]
          when :textile
            require 'redcloth'
            klass = 'RedCloth'
          else
            raise ActsAsMarkup::UnsportedMarkupLanguage, "#{options[:langauge]} is not a currently supported markup language."
          end
          
          options[:columns].each do |col|
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
          end
        end
        
        ##
        # This is a convenience method for 
        # +acts_as_markup :language => :markdown, :columns => [:body]+
        # 
        def acts_as_markdown(*columns)
          acts_as_markup :language => :markdown, :columns => columns
        end
        
        ##
        # This is a convenience method for 
        # +acts_as_markup :language => :textile, :columns => [:body]+
        #
        def acts_as_textile(*columns)
          acts_as_markup :language => :textile, :columns => columns
        end
        
      end
    end
  end
end

ActiveRecord::Base.send :include, ActiveRecord::Acts::AsMarkup
