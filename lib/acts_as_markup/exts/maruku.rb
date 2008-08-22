require 'maruku'

class Maruku
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
    		e = []
    		array.each do |c|
    			method = c.kind_of?(MDElement) ? 
    			   "to_html_#{c.node_type}" : "to_xml"

    			if not c.respond_to?(method)
    				#raise "Object does not answer to #{method}: #{c.class} #{c.inspect}"
    				next
    			end

    			h =  c.send(method)

    			if h.nil?
    				raise "Nil html created by method  #{method}:\n#{h.inspect}\n"+
    				" for object #{c.inspect[0,300]}"
    			end

    			if h.kind_of?Array
    				e = e + h #h.each do |hh| e << hh end
    			else
    				e << h
    			end
    		end
    		e
    	end

    end
  end
end
