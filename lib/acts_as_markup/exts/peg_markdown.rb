require 'peg_markdown'

class PEGMarkdown
  include Stringlike
  
  # used to be compatable with Rails/ActiveSupport
  def blank?
    self.text.blank?
  end
end
