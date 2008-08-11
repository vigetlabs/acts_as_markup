require 'wikitext'

# This allows a us to create a wrapper object similar to those provided by the
# Markdown and Textile libraries. It stores the original and formated HTML text
# in instance variables.
# 
class WikitextString < String
  attr_reader :text
  attr_reader :html
  
  def initialize(str)
    super(str)
    @text = str.to_s
    @html = Wikitext::Parser.new.parse(@text)
  end
  
  def to_html
    @html
  end
end
