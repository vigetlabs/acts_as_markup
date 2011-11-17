require 'wikicloth'

class WikiClothText < WikiCloth::Parser
  include Stringlike
  
  def initialize(string)
    @text = string
    super({:data => string.to_s})
  end
  
  def to_s
    @text
  end
  
  def blank?
    @text.blank?
  end
end