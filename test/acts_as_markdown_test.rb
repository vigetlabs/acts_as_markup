require File.dirname(__FILE__) + '/test_helper'

class ActsAsMarkdownTest < ActsAsMarkupTestCase
  context 'acts_as_markdown' do
    setup do
      @markdown_text = '## Markdown Test Text'
    end

    context 'using RDiscount' do
      setup do
        ActsAsMarkup.markdown_library = :rdiscount
        class ::Post < ActiveRecord::Base
          acts_as_markdown :body
        end
        @post = Post.create!(:title => 'Blah', :body => @markdown_text)
      end
      
      should_act_like_a_string

      should "have a RDiscount object returned for the column value" do
        assert_kind_of RDiscount, @post.body
      end

      should "return original markdown text for a `to_s` method call on the column value" do
        assert_equal @markdown_text, @post.body.to_s
      end
      
      should 'return false for .blank?' do
        assert !@post.body.blank?
      end

      should "return formatted html for a `to_html` method call on the column value" do
        assert_match(/<h2(\s\w+\=['"]\w*['"])*\s*>\s*Markdown Test Text\s*<\/h2>/, @post.body.to_html)
      end
    
      should "not return escaped html" do
        @post.body = "## Markdown <i>Test</i> Text"
        assert_match(/<i>Test<\/i>/, @post.body.to_html)
      end

      context "changing value of markdown field should return new markdown object" do
        setup do
          @old_body = @post.body
          @post.body = "`@count = 20`"
        end

        should "still have an RDiscount object but not the same object" do
          assert_kind_of RDiscount, @post.body
          assert_not_same @post.body, @old_body 
        end

        should "return correct text for `to_s`" do
          assert_equal "`@count = 20`", @post.body.to_s
        end

        should "return correct HTML for the `to_html` method" do
          assert_match(/<code>\s*\@count\s\=\s20\s*<\/code>/, @post.body.to_html)
        end

        teardown do
          @old_body = nil
        end
      end

      teardown do
        @post = nil
        Post.delete_all
      end
    end
    
    context 'using RDiscount with options' do
      setup do
        class ::Post
          acts_as_markdown :body, :markdown_options => [ :filter_html ]
        end
        @post = Post.new(:title => 'Blah')
      end
      
      should "return escaped html because of :filter_html" do
        @post.body = "## Markdown <i>Test</i> Text"
        assert_match(/&lt;i>Test&lt;\/i>/, @post.body.to_html)
      end
    end

    context 'using Ruby PEG Markdown' do
      setup do
        ActsAsMarkup.markdown_library = :rpeg
        class ::Post < ActiveRecord::Base
          acts_as_markdown :body
        end
        @post = Post.create!(:title => 'Blah', :body => @markdown_text)
      end
      
      should_act_like_a_string

      should "have a Ruby PEG Markdown object returned for the column value" do
        assert_kind_of PEGMarkdown, @post.body
      end

      should "return original markdown text for a `to_s` method call on the column value" do
        assert_equal @markdown_text, @post.body.to_s
      end
      
      should 'return false for .blank?' do
        assert !@post.body.blank?
      end

      should "return formated html for a `to_html` method call on the column value" do
        assert_match(/<h2(\s\w+\=['"]\w*['"])*\s*>\s*Markdown Test Text\s*<\/h2>/, @post.body.to_html)
      end
    
      should "not return escaped html" do
        @post.body = "## Markdown <i>Test</i> Text"
        assert_match(/<i>Test<\/i>/, @post.body.to_html)
      end

      context "changing value of markdown field should return new markdown object" do
        setup do
          @old_body = @post.body
          @post.body = "`@count = 20`"
        end

        should "still have an PEGMarkdown object but not the same object" do
          assert_kind_of PEGMarkdown, @post.body
          assert_not_same @post.body, @old_body 
        end

        should "return correct text for `to_s`" do
          assert_equal "`@count = 20`", @post.body.to_s
        end

        should "return correct HTML for the `to_html` method" do
          assert_match(/<code>\s*\@count\s\=\s20\s*<\/code>/, @post.body.to_html)
        end

        teardown do
          @old_body = nil
        end
      end

      teardown do
        @post = nil
        Post.delete_all
      end
    end

    context 'using Ruby PEG Markdown with options' do
      setup do
        class ::Post
          acts_as_markdown :body, :markdown_options => [ :filter_html ]
        end
        @post = Post.new(:title => 'Blah')
      end
      
      should "return no html because of :filter_html" do
        @post.body = "## Markdown <i>Test</i> Text"
        assert_match(/Markdown Test Text/, @post.body.to_html)
      end
    end

    context 'using BlueCloth' do
      setup do
        ActsAsMarkup.markdown_library = :bluecloth
        class ::Post < ActiveRecord::Base
          acts_as_markdown :body
        end
        @post = Post.create!(:title => 'Blah', :body => @markdown_text)
      end
      
      should_act_like_a_string

      should "have a BlueCloth object returned for the column value" do
        assert_kind_of BlueCloth, @post.body
      end

      should "return original markdown text for a `to_s` method call on the column value" do
        assert_equal @markdown_text, @post.body.to_s
      end
      
      should 'return false for .blank?' do
        assert !@post.body.blank?
      end

      should "return formated html for a `to_html` method call on the column value" do
        assert_match(/<h2(\s\w+\=['"]\w*['"])*\s*>\s*Markdown Test Text\s*<\/h2>/, @post.body.to_html)
      end
    
      should "not return escaped html" do
        @post.body = "## Markdown <i>Test</i> Text"
        assert_match(/<i>Test<\/i>/, @post.body.to_html)
      end

      context "changing value of markdown field should return new markdown object" do
        setup do
          @old_body = @post.body
          @post.body = "`@count = 20`"
        end

        should "still have an BlueCloth object but not the same object" do
          assert_kind_of BlueCloth, @post.body
          assert_not_same @post.body, @old_body 
        end

        should "return correct text for `to_s`" do
          assert_equal "`@count = 20`", @post.body.to_s
        end

        should "return correct HTML for the `to_html` method" do
          assert_match(/<code>\s*\@count\s\=\s20\s*<\/code>/, @post.body.to_html)
        end

        teardown do
          @old_body = nil
        end
      end

      teardown do
        @post = nil
        Post.delete_all
      end
    end
    
    context 'using BlueCloth with options' do
      setup do
        class ::Post
          acts_as_markdown :body, :markdown_options => [ :filter_html ]
        end
        @post = Post.new(:title => 'Blah')
      end
      
      should "return escaped html because of :filter_html" do
        @post.body = "## Markdown <i>Test</i> Text"
        assert_match(/&lt;i&gt;Test&lt;\/i&gt;/, @post.body.to_html)
      end
    end
    
    context 'using Maruku' do
      setup do
        ActsAsMarkup.markdown_library = :maruku
        class ::Post < ActiveRecord::Base
          acts_as_markdown :body
        end
        @post = Post.create!(:title => 'Blah', :body => @markdown_text)
      end
      
      should_act_like_a_string

      should "have a Maruku object returned for the column value" do
        assert_kind_of Maruku, @post.body
      end

      should "return original markdown text for a `to_s` method call on the column value" do
        assert_equal @markdown_text, @post.body.to_s
      end
      
      should 'return false for .blank?' do
        assert !@post.body.blank?
      end

      should "return formated html for a `to_html` method call on the column value" do
        assert_match(/<h2(\s\w+\=['"]\w*['"])*\s*>\s*Markdown Test Text\s*<\/h2>/, @post.body.to_html)
      end

      context "changing value of markdown field should return new markdown object" do
        setup do
          @old_body = @post.body
          @post.body = "`@count = 20`"
        end

        should "still have an Maruku object but not the same object" do
          assert_kind_of Maruku, @post.body
          assert_not_same @post.body, @old_body 
        end

        should "return correct text for `to_s`" do
          assert_equal "`@count = 20`", @post.body.to_s
        end

        should "return correct HTML for the `to_html` method" do
          assert_match(/<code>\s*\@count\s\=\s20\s*<\/code>/, @post.body.to_html)
        end

        teardown do
          @old_body = nil
        end
      end

      teardown do
        @post = nil
        Post.delete_all
      end
    end
    
    teardown do
      @markdown_text = nil
    end
  end
end
