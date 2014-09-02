class RedcarpetText < String

  attr_reader :text
  attr_reader :markdown_processor

  def initialize(text, options = {})
    super(text)
    @text = text
    @markdown_processor = Redcarpet::Markdown.new(Redcarpet::Render::HTML, {:autolink => true}.merge(options))
  end

  def to_html
    markdown_processor.render(text)
  end

end
