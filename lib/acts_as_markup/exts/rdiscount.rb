require 'rdiscount'

class RDiscount
  # Used to get the original Markdown text.
  def to_s
    self.text
  end
end
