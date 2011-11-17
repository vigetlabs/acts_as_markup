class Redcarpet
  include Stringlike
  
  alias_method :to_s, :text
  
  def blank?
    text.blank?
  end
end
