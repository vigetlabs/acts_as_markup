require 'rdiscount'

class RDiscount
  include Stringlike
  
  # Used to get the original Markdown text.
  def to_s
    self.text
  end
  
  # used to be compatable with Rails/ActiveSupport
  def blank?
    self.text.blank?
  end
end
