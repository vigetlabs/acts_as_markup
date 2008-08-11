require 'rdoc/markup/simple_markup'
require 'rdoc/markup/simple_markup/to_html'

class RDocWithHyperlinkToHtml < SM::ToHtml

  # Generate a hyperlink for url, labeled with text. Handle the
  # special cases for img: and link: described under handle_special_HYPEDLINK
  # 
  def gen_url(url, text)
    if url =~ /([A-Za-z]+):(.*)/
      type = $1
      path = $2
    else
      type = "http"
      path = url
      url  = "http://#{url}"
    end

    if type == "link"
      if path[0,1] == '#'  # is this meaningful?
        url = path
      else
        url = HTMLGenerator.gen_url(@from_path, path)
      end
    end

    if (type == "http" || type == "link") && url =~ /\.(gif|png|jpg|jpeg|bmp)$/
      "<img src=\"#{url}\" />"
    else
      "<a href=\"#{url}\">#{text.sub(%r{^#{type}:/*}, '')}</a>"
    end
  end
  
  # And we're invoked with a potential external hyperlink mailto:
  # just gets inserted. http: links are checked to see if they
  # reference an image. If so, that image gets inserted using an
  # <img> tag. Otherwise a conventional <a href> is used.  We also
  # support a special type of hyperlink, link:, which is a reference
  # to a local file whose path is relative to the --op directory.
  # 
  def handle_special_HYPERLINK(special)
    url = special.text
    gen_url(url, url)
  end

  # Here's a hypedlink where the label is different to the URL
  #    <label>[url]
  # 
  def handle_special_TIDYLINK(special)
    text = special.text
    unless text =~ /\{(.*?)\}\[(.*?)\]/ or text =~ /(\S+)\[(.*?)\]/ 
      return text
    end
    label = $1
    url   = $2
    gen_url(url, label)
  end

end

# This allows a us to create a wrapper object similar to those provided by the
# Markdown and Textile libraries. It stores the original and formated HTML text
# in instance variables. It also stores the SimpleMarkup parser objects in
# instance variables.
#
class RDocText < String
  attr_reader :text
  attr_reader :html
  attr_reader :markup
  attr_reader :html_formater
  
  def initialize(str)
    super(str)
    @text = str.to_s
    @markup = SM::SimpleMarkup.new
    
    # external hyperlinks
    @markup.add_special(/((link:|https?:|mailto:|ftp:|www\.)\S+\w)/, :HYPERLINK)

    # and links of the form  <text>[<url>]
    @markup.add_special(/(((\{.*?\})|\b\S+?)\[\S+?\.\S+?\])/, :TIDYLINK)
    
    # Convert leading comment markers to spaces, but only
    # if all non-blank lines have them

    if str =~ /^(?>\s*)[^\#]/
      content = str
    else
      content = str.gsub(/^\s*(#+)/)  { $1.tr('#',' ') }
    end
    
    @html_formatter = RDocWithHyperlinkToHtml.new
    
    @html = @markup.convert(@text, @html_formatter)
  end
  
  def to_html
    @html
  end
end

