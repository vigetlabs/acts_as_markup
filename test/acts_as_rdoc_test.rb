require File.dirname(__FILE__) + '/test_helper'

class ActsAsRDocTest < ActsAsMarkupTestCase
  context 'acts_as_rdoc' do
    setup do
      @rdoctext = "== RDoc Test Text"
      class ::Post < ActiveRecord::Base
        acts_as_rdoc :body
      end
      @post = Post.create!(:title => 'Blah', :body => @rdoctext)
    end
    
    should "have a RDocText object returned for the column value" do
      assert_kind_of RDocText, @post.body
    end
  
    should "return original RDoc text for a `to_s` method call on the column value" do
      assert_equal @rdoctext, @post.body.to_s
    end
    
    should 'return false for .blank?' do
      assert !@post.body.blank?
    end
  
    should "return formated html for a `to_html` method call on the column value" do
      assert_match(/<h2>\s*RDoc Test Text\s*<\/h2>/, @post.body.to_html)
    end
  
    context "changing value of RDoc field should return new RDoc object" do
      setup do
        @old_body = @post.body
        @post.body = "http://www.example.com/"
      end
    
      should "still have an RDocText object but not the same object" do
        assert_kind_of RDocText, @post.body
        assert_not_same @post.body, @old_body 
      end
    
      should "return correct text for `to_s`" do
        assert_equal "http://www.example.com/", @post.body.to_s
      end
    
      should "return correct HTML for the `to_html` method" do
        assert_match(/<a href="http:\/\/www.example.com">www.example.com<\/a>/, @post.body.to_html)
      end
    
      teardown do
        @old_body = nil
      end
    end
    
    teardown do
      @rdoctext, @post = nil
      Post.delete_all
    end
  end
end
