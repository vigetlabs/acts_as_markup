require File.dirname(__FILE__) + '/test_helper'

class ActsAsMediawikiTest < ActsAsMarkupTestCase
  context 'acts_as_mediawiki' do
    setup do
      @wikitext = "== Wikitext Test Text =="
    end
    
    context 'using Wikitext' do
      setup do
        ActsAsMarkup.mediawiki_library = :wikitext
        class ::Post < ActiveRecord::Base
          acts_as_mediawiki :body
        end
        @post = Post.create!(:title => 'Blah', :body => @wikitext)
      end
      
      should "have a WikitextString object returned for the column value" do
        assert_kind_of WikitextString, @post.body
      end

      should "return original wikitext text for a `to_s` method call on the column value" do
        assert_equal @wikitext, @post.body.to_s
      end

      should 'return false for .blank?' do
        assert !@post.body.blank?
      end

      should "return formated html for a `to_html` method call on the column value" do
        assert_match(/<h2>Wikitext Test Text<\/h2>/, @post.body.to_html)
      end

      should "underscore spaces in URLs" do
        @post.body = "[[foo bar]]"
        assert_match(/<a href="\/wiki\/foo_bar">foo bar<\/a>/, @post.body.to_html)
      end

      context "changing value of wikitext field should return new wikitext object" do
        setup do
          @old_body = @post.body
          @post.body = "`@count = 20`"
        end

        should "still have an WikitextString object but not the same object" do
          assert_kind_of WikitextString, @post.body
          assert_not_same @post.body, @old_body 
        end

        should "return correct text for `to_s`" do
          assert_equal "`@count = 20`", @post.body.to_s
        end

        should "return correct HTML for the `to_html` method" do
          assert_match(/<p><code>\@count\s\=\s20<\/code><\/p>/, @post.body.to_html)
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
    
    context 'using Wikitext with options' do
      setup do
        ActsAsMarkup.mediawiki_library = :wikitext
        class ::Post
          acts_as_mediawiki :body, :mediawiki_options => [ { :space_to_underscore => false } ]
        end
        @post = Post.new(:title => 'Blah')
      end
      
      should "not underscore spaces in URLs because of :space_to_underscore option" do
        @post.body = "[[foo bar]]"
        assert_match(/<a href="\/wiki\/foo%20bar">foo bar<\/a>/, @post.body.to_html)
      end
      
      teardown do
        @post = nil
      end
    end
    
    context 'using WikiCloth' do
      setup do
        ActsAsMarkup.mediawiki_library = :wikicloth
        class ::Post < ActiveRecord::Base
          acts_as_mediawiki :body
        end
        @post = Post.create!(:title => 'Blah', :body => @wikitext)
      end
      
      should "have a WikitextString object returned for the column value" do
        assert_kind_of WikiClothText, @post.body
      end

      should "return original wikitext text for a `to_s` method call on the column value" do
        assert_equal @wikitext, @post.body.to_s
      end

      should 'return false for .blank?' do
        assert !@post.body.blank?
      end

      should "return formated html for a `to_html` method call on the column value" do
        assert_match(/<h2>.*Wikitext Test Text.*<\/h2>/, @post.body.to_html)
      end

      should "render a link" do
        @post.body = "[http://www.example.com/ Test]"
        assert_match(%r[<a href="http://www.example.com/" target="_blank">Test</a>], @post.body.to_html)
      end

      context "changing value of wikitext field should return new wikitext object" do
        setup do
          @old_body = @post.body
          @post.body = "'''This is very important'''"
        end

        should "still have an WikitextString object but not the same object" do
          assert_kind_of WikiClothText, @post.body
          assert_not_same @post.body, @old_body 
        end

        should "return correct text for `to_s`" do
          assert_equal "'''This is very important'''", @post.body.to_s
        end

        should "return correct HTML for the `to_html` method" do
          assert_match(/<p><b>This is very important<\/b><\/p>/, @post.body.to_html)
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
      @wikitext = nil
    end
  end
end
