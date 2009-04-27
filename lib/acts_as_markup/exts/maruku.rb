require 'maruku'

class Maruku
  include Stringlike
  
  attr_reader :text
  
  def initialize(s=nil, meta={})
    super(nil)
    self.attributes.merge! meta
    if s
      @text = s
      parse_doc(s)
    end
  end
  
  # Used to get the original Markdown text.
  def to_s
    @text
  end
  
  # used to be compatable with Rails/ActiveSupport
  def blank?
    @text.blank?
  end
  
end

class String
  alias_method :to_html, :to_s
  
  def to_xml
    REXML::Text.new(self)
  end
end

module MaRuKu # :nodoc:
  module Out # :nodoc:
    module HTML
      
      # We patch this method to play nicely with our own modifications of String.
      #
      # It originally used a +to_html+ method on String we've swapped this out for a +to_xml+ 
      # method because we need +to_html+ to return the original text on plain text fields of
      # the variable language option on +acts_as_markup+
      def array_to_html(array)
        elements = []
        array.each do |item|
          method = item.kind_of?(MDElement) ? "to_html_#{item.node_type}" : "to_xml"
          unless item.respond_to?(method)
            next
          end

          html_text =  item.send(method)
          if html_text.nil?
            raise "Nil html created by method  #{method}:\n#{html_text.inspect}\n for object #{item.inspect[0,300]}"
          end

          if html_text.kind_of?Array
            elements = elements + html_text
          else
            elements << html_text
          end
        end
        elements
      end

    end
  end
end
