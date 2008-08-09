require File.dirname(__FILE__) + '/test_helper'

class ActsAsWikitextTest < ActsAsMarkupTestCase
  context 'acts_as_wikitext' do
    setup do
      @wikitext = "== Wikitext Test Text =="
      class ::Post < ActiveRecord::Base
        acts_as_wikitext :body
      end
      @post = Post.create!(:title => 'Blah', :body => @wikitext)
    end
    
    should "have a WikitextString object returned for the column value" do
      assert_kind_of WikitextString, @post.body
    end
  
    should "return original wikitext text for a `to_s` method call on the column value" do
      assert_equal @wikitext, @post.body.to_s
    end
  
    should "return formated html for a `to_html` method call on the column value" do
      assert_match(/<h2>Wikitext Test Text<\/h2>/, @post.body.to_html)
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
        assert_match(/<tt>\@count\s\=\s20<\/tt>/, @post.body.to_html)
      end
    
      teardown do
        @old_body = nil
      end
    end
    
    teardown do
      @wikitext, @post = nil
      Post.delete_all
    end
  end
end
