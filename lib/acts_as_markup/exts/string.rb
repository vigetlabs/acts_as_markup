module ActsAsMarkup
  module StringExtension
    def to_html
      self.to_s
    end
  end
end

String.send :include, ActsAsMarkup::StringExtension
