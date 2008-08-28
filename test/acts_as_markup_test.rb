require File.dirname(__FILE__) + '/test_helper'

class ActsAsMarkupTest < ActsAsMarkupTestCase
  def setup
    setup_db
  end
  
  context 'acts_as_markup' do
    setup do
      ActsAsMarkup.markdown_library = ActsAsMarkup::DEFAULT_MARKDOWN_LIB
      
      @textile_text = "h2. Textile Test Text"
      class ::TextilePost < ActiveRecord::Base
        acts_as_markup :language => :textile, :columns => [:body]
      end
      @textile_post = TextilePost.create!(:title => 'Blah', :body => @textile_text)
      
      @markdown_text = '## Markdown Test Text'
      class ::MarkdownPost < ActiveRecord::Base
        acts_as_markup :language => :markdown, :columns => [:body]
      end
      @markdown_post = MarkdownPost.create!(:title => 'Blah', :body => @markdown_text)
    end
    
    should "have a markup object returned for the column value" do
      assert_kind_of RedCloth::TextileDoc, @textile_post.body
      assert_kind_of RDiscount, @markdown_post.body
    end
    
    should "return original markup text for a `to_s` method call on the column value" do
      assert_equal @markdown_text, @markdown_post.body.to_s
      assert_equal @textile_text, @textile_post.body.to_s
    end
  
    should "return formated html for a `to_html` method call on the column value" do
      assert_match(/<h2(\s\w+\=['"]\w*['"])*\s*>\s*Markdown Test Text\s*<\/h2>/, @markdown_post.body.to_html)
      assert_match(/<h2>Textile Test Text<\/h2>/, @textile_post.body.to_html)
    end
  
    context "changing value of markup field should return new markup object" do
      setup do
        @markdown_old_body = @markdown_post.body
        @markdown_post.body = "`@count = 20`"
        @textile_old_body = @textile_post.body
        @textile_post.body = "@@count = 20@"
      end
    
      should "still have an markup object but not the same object" do
        assert_kind_of RedCloth::TextileDoc, @textile_post.body
        assert_not_same @markdown_post.body, @markdown_old_body
        assert_kind_of RDiscount, @markdown_post.body
        assert_not_same @textile_post.body, @textile_old_body
      end
    
      should "return correct text for `to_s`" do
        assert_equal "`@count = 20`", @markdown_post.body.to_s
        assert_equal "@@count = 20@", @textile_post.body.to_s
      end
    
      should "return correct HTML for the `to_html` method" do
        assert_match(/<code>\s*\@count\s\=\s20\s*<\/code>/, @markdown_post.body.to_html)
        assert_match(/<code>\@count\s\=\s20<\/code>/, @textile_post.body.to_html)
      end
    
      teardown do
        @markdown_old_body, @textile_old_body = nil
      end
    end
    
    teardown do
      @textile_text, @textile_post, @markdown_text, @markdown_post = nil
      TextilePost.delete_all
      MarkdownPost.delete_all
    end
  end
  
  context 'acts_as_markup with variable language' do
    setup do
      ActsAsMarkup.markdown_library = ActsAsMarkup::DEFAULT_MARKDOWN_LIB
      class ::VariablePost < ActiveRecord::Base
        acts_as_markup :language => :variable, :columns => [:body]
      end
    end
    
    context "with a Markdown post" do
      setup do
        @markdown_text = '## Markdown Test Text'
        @markdown_post = VariablePost.create!(:title => 'Blah', :body => @markdown_text, :markup_language => 'Markdown')
      end
      
      should "have a markup object returned for the column value" do
        assert_kind_of RDiscount, @markdown_post.body
      end

      should "return original markup text for a `to_s` method call on the column value" do
        assert_equal @markdown_text, @markdown_post.body.to_s
      end

      should "return formated html for a `to_html` method call on the column value" do
        assert_match(/<h2(\s\w+\=['"]\w*['"])*\s*>\s*Markdown Test Text\s*<\/h2>/, @markdown_post.body.to_html)
      end

      context "changing value of markup field should return new markup object" do
        setup do
          @markdown_old_body = @markdown_post.body
          @markdown_post.body = "`@count = 20`"
        end

        should "still have an markup object but not the same object" do
          assert_not_same @markdown_post.body, @markdown_old_body
          assert_kind_of RDiscount, @markdown_post.body
        end

        should "return correct text for `to_s`" do
          assert_equal "`@count = 20`", @markdown_post.body.to_s
        end

        should "return correct HTML for the `to_html` method" do
          assert_match(/<code>\s*\@count\s\=\s20\s*<\/code>/, @markdown_post.body.to_html)
        end

        teardown do
          @markdown_old_body = nil
        end
      end
      
      teardown do
        @markdown_text, @markup_post = nil
      end
    end
    
    context "with a Textile post" do
      setup do
        @textile_text = "h2. Textile Test Text"
        @textile_post = VariablePost.create!(:title => 'Blah', :body => @textile_text, :markup_language => 'Textile')
      end
      
      should "have a markup object returned for the column value" do
        assert_kind_of RedCloth::TextileDoc, @textile_post.body
      end

      should "return original markup text for a `to_s` method call on the column value" do
        assert_equal @textile_text, @textile_post.body.to_s
      end

      should "return formated html for a `to_html` method call on the column value" do
        assert_match(/<h2>Textile Test Text<\/h2>/, @textile_post.body.to_html)
      end

      context "changing value of markup field should return new markup object" do
        setup do
          @textile_old_body = @textile_post.body
          @textile_post.body = "@@count = 20@"
        end

        should "still have an markup object but not the same object" do
          assert_kind_of RedCloth::TextileDoc, @textile_post.body
          assert_not_same @textile_post.body, @textile_old_body
        end

        should "return correct text for `to_s`" do
          assert_equal "@@count = 20@", @textile_post.body.to_s
        end

        should "return correct HTML for the `to_html` method" do
          assert_match(/<code>\@count\s\=\s20<\/code>/, @textile_post.body.to_html)
        end

        teardown do
          @textile_old_body = nil
        end
      end
      
      teardown do
        @textile_text, @textile_post = nil
      end
    end
    
    context 'with a Wikitext post' do
      setup do
        @wikitext = "== Wikitext Test Text =="
        @wikitext_post = VariablePost.create!(:title => 'Blah', :body => @wikitext, :markup_language => 'Wikitext')
      end

      should "have a WikitextString object returned for the column value" do
        assert_kind_of WikitextString, @wikitext_post.body
      end

      should "return original wikitext text for a `to_s` method call on the column value" do
        assert_equal @wikitext, @wikitext_post.body.to_s
      end

      should "return formated html for a `to_html` method call on the column value" do
        assert_match(/<h2>Wikitext Test Text<\/h2>/, @wikitext_post.body.to_html)
      end

      context "changing value of wikitext field should return new wikitext object" do
        setup do
          @old_body = @wikitext_post.body
          @wikitext_post.body = "`@count = 20`"
        end

        should "still have an WikitextString object but not the same object" do
          assert_kind_of WikitextString, @wikitext_post.body
          assert_not_same @wikitext_post.body, @old_body 
        end

        should "return correct text for `to_s`" do
          assert_equal "`@count = 20`", @wikitext_post.body.to_s
        end

        should "return correct HTML for the `to_html` method" do
          assert_match(/<tt>\@count\s\=\s20<\/tt>/, @wikitext_post.body.to_html)
        end

        teardown do
          @old_body = nil
        end
      end

      teardown do
        @wikitext, @wikitext_post = nil
        Post.delete_all
      end
    end
    
    context 'with a RDoc post' do
      setup do
        @rdoctext = "== RDoc Test Text"
        @rdoc_post = VariablePost.create!(:title => 'Blah', :body => @rdoctext, :markup_language => 'RDoc')
      end

      should "have a RDocText object returned for the column value" do
        assert_kind_of RDocText, @rdoc_post.body
      end

      should "return original RDoc text for a `to_s` method call on the column value" do
        assert_equal @rdoctext, @rdoc_post.body.to_s
      end

      should "return formated html for a `to_html` method call on the column value" do
        assert_match(/<h2>\s*RDoc Test Text\s*<\/h2>/, @rdoc_post.body.to_html)
      end

      context "changing value of RDoc field should return new RDoc object" do
        setup do
          @old_body = @rdoc_post.body
          @rdoc_post.body = "http://www.example.com/"
        end

        should "still have an RDocText object but not the same object" do
          assert_kind_of RDocText, @rdoc_post.body
          assert_not_same @rdoc_post.body, @old_body 
        end

        should "return correct text for `to_s`" do
          assert_equal "http://www.example.com/", @rdoc_post.body.to_s
        end

        should "return correct HTML for the `to_html` method" do
          assert_match(/<a href="http:\/\/www.example.com">www.example.com<\/a>/, @rdoc_post.body.to_html)
        end

        teardown do
          @old_body = nil
        end
      end

      teardown do
        @rdoctext, @rdoc_post = nil
        Post.delete_all
      end
    end
    
    context "with a plain text post" do
      setup do
        @plain_text = "Hahaha!!!"
        @plain_text_post = VariablePost.create!(:title => 'Blah', :body => @plain_text, :markup_language => 'text')
      end
      
      should "have a string object returned for the column value" do
        assert_kind_of String, @plain_text_post.body
      end

      should "return the original string with a `to_s` method call on the column value" do
        assert_equal @plain_text, @plain_text_post.body.to_s
      end
      
      # FIXME: why is this failing??? both objects are String, both have EXACTLY the same value when output
      #        in failure message. assert_equal does not require same object. This is very odd!
      should "return the original string with a `to_html` method call on the column value" do
        assert_equal @plain_text, @plain_text_post.body.to_html
      end

      context "changing value of markup field should return new markup object" do
        setup do
          @plaintext_old_body = @plain_text_post.body
          @plain_text_post.body = "Lorem ipsum dolor sit amet"
        end

        should "still have an markup object but not the same object" do
          assert_kind_of String, @plain_text_post.body
          assert_not_same @plain_text_post.body, @plaintext_old_body
        end

        should "return correct text for `to_s`" do
          assert_equal "Lorem ipsum dolor sit amet", @plain_text_post.body.to_s
        end

        teardown do
          @textile_old_body = nil
        end
      end
      
      teardown do
        @textile_text, @textile_post = nil
      end
    end
    
    
    teardown do
      VariablePost.delete_all
    end
  end
  
  context 'acts_as_markup with variable language setting the language column' do
    setup do
      ActsAsMarkup.markdown_library = ActsAsMarkup::DEFAULT_MARKDOWN_LIB
      class ::VariableLanguagePost < ActiveRecord::Base
        acts_as_markup :language => :variable, :columns => [:body], :language_column => :language_name
      end
    end
    
    should "use the correct language column" do
      markdown_text = '## Markdown Test Text'
      markdown_post = VariableLanguagePost.create!(:title => 'Blah', :body => markdown_text, :language_name => 'Markdown')
      
      assert_kind_of RDiscount, markdown_post.body
      assert_equal markdown_text, markdown_post.body.to_s
      assert_match(/<h2(\s\w+\=['"]\w*['"])*\s*>\s*Markdown Test Text\s*<\/h2>/, markdown_post.body.to_html)
    end
    
    teardown do
      VariableLanguagePost.delete_all
    end
  end
  
  context 'with a nil value for the text' do
    setup do
      @text = nil
    end
    
    context 'with textile' do
      setup do
        class ::Post < ActiveRecord::Base
          acts_as_textile :body
        end
        @post = Post.create!(:title => 'Blah', :body => @text)
      end
      
      should 'return a blank string for `to_s` method' do
        assert_equal @post.body.to_s, ''
      end
      
      should 'return true for .blank?' do
        assert @post.body.blank?
      end
      
      should 'return a blank string for `to_html` method' do
        assert_match(/[\n\s]*/, @post.body.to_html)
      end
      
      should "have a RedCloth object returned for the column value" do
        assert_kind_of RedCloth::TextileDoc, @post.body
      end
      
      teardown do
        @post = nil
        Post.delete_all
      end
    end
    
    context 'with wikitext' do
      setup do
        class ::Post < ActiveRecord::Base
          acts_as_wikitext :body
        end
        @post = Post.create!(:title => 'Blah', :body => @text)
      end
      
      should 'return a blank string for `to_s` method' do
        assert_equal @post.body.to_s, ''
      end
      
      should 'return true for .blank?' do
        assert @post.body.blank?
      end
      
      should 'return a blank string for `to_html` method' do
        assert_match(/[\n\s]*/, @post.body.to_html)
      end
      
      should "have a WikitextString object returned for the column value" do
        assert_kind_of WikitextString, @post.body
      end
      
      teardown do
        @post = nil
        Post.delete_all
      end
    end
    
    context 'with RDoc' do
      setup do
        class ::Post < ActiveRecord::Base
          acts_as_rdoc :body
        end
        @post = Post.create!(:title => 'Blah', :body => @text)
      end
      
      should 'return a blank string for `to_s` method' do
        assert_equal @post.body.to_s, ''
      end
      
      should 'return true for .blank?' do
        assert @post.body.blank?
      end
      
      should 'return a blank string for `to_html` method' do
        assert_match(/[\n\s]*/, @post.body.to_html)
      end
      
      should "have a RDocText object returned for the column value" do
        assert_kind_of RDocText, @post.body
      end
      
      teardown do
        @post = nil
        Post.delete_all
      end
    end
    
    context 'with RDiscount Markdown' do
      setup do
        ActsAsMarkup.markdown_library = :rdiscount
        class ::Post < ActiveRecord::Base
          acts_as_markdown :body
        end
        @post = Post.create!(:title => 'Blah', :body => @text)
      end
      
      should 'return a blank string for `to_s` method' do
        assert_equal @post.body.to_s, ''
      end
      
      should 'return true for .blank?' do
        assert @post.body.blank?
      end
      
      should 'return a blank string for `to_html` method' do
        assert_match(/[\n\s]*/, @post.body.to_html)
      end
      
      should "have a RDiscount object returned for the column value" do
        assert_kind_of RDiscount, @post.body
      end
      
      teardown do
        @post = nil
        Post.delete_all
      end
    end
    
    context 'with BlueCloth Markdown' do
      setup do
        ActsAsMarkup.markdown_library = :bluecloth
        class ::Post < ActiveRecord::Base
          acts_as_markdown :body
        end
        @post = Post.create!(:title => 'Blah', :body => @text)
      end
      
      should 'return a blank string for `to_s` method' do
        assert_equal @post.body.to_s, ''
      end
      
      should 'return true for .blank?' do
        assert @post.body.blank?
      end
      
      should 'return a blank string for `to_html` method' do
        assert_match(/[\n\s]*/, @post.body.to_html)
      end
      
      should "have a BlueCloth object returned for the column value" do
        assert_kind_of BlueCloth, @post.body
      end
      
      teardown do
        @post = nil
        Post.delete_all
      end
    end
    
    context 'with Ruby PEG Markdown' do
      setup do
        ActsAsMarkup.markdown_library = :rpeg
        class ::Post < ActiveRecord::Base
          acts_as_markdown :body
        end
        @post = Post.create!(:title => 'Blah', :body => @text)
      end
      
      should 'return a blank string for `to_s` method' do
        assert_equal @post.body.to_s, ''
      end
      
      should 'return true for .blank?' do
        assert @post.body.blank?
      end
      
      should 'return a blank string for `to_html` method' do
        assert_match(/[\n\s]*/, @post.body.to_html)
      end
      
      should "have a PEGMarkdown object returned for the column value" do
        assert_kind_of PEGMarkdown, @post.body
      end
      
      teardown do
        @post = nil
        Post.delete_all
      end
    end
    
    context 'with Maruku Markdown' do
      setup do
        ActsAsMarkup.markdown_library = :maruku
        class ::Post < ActiveRecord::Base
          acts_as_markdown :body
        end
        @post = Post.create!(:title => 'Blah', :body => @text)
      end
      
      should 'return a blank string for `to_s` method' do
        assert_equal @post.body.to_s, ''
      end
      
      should 'return true for .blank?' do
        assert @post.body.blank?
      end
      
      should 'return a blank string for `to_html` method' do
        assert_match(/[\n\s]*/, @post.body.to_html)
      end
      
      should "have a Maruku object returned for the column value" do
        assert_kind_of Maruku, @post.body
      end
      
      teardown do
        @post = nil
        Post.delete_all
      end
    end
  end
  
  context 'acts_as_markup with bad language name' do
    should 'raise exception when a non-supported language is passed to acts_as_markup' do
      assert_raise ActsAsMarkup::UnsupportedMarkupLanguage do
        class ::Post < ActiveRecord::Base
          acts_as_markup :language => :fake, :columns => [:body]
        end
      end
    end
  end
  
  context 'acts_as_markup with bad markdown library' do
    should 'raise exception when a non-supported library is set as the markdown library attribute on ActsAsMarkup' do
      assert_raise ActsAsMarkup::UnsportedMarkdownLibrary do
        ActsAsMarkup.markdown_library = :fake
        class ::Post < ActiveRecord::Base
          acts_as_markup :language => :markdown, :columns => [:body]
        end
      end
    end
  end
  
  def teardown
    teardown_db
  end
end

