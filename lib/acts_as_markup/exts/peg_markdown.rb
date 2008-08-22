require 'peg_markdown'

class PEGMarkdown
  # used to be compatable with Rails/ActiveSupport
  def blank?
    self.text.blank?
  end
end
