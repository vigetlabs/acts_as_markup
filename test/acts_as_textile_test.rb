require File.dirname(__FILE__) + '/test_helper'

class ActsAsTextileTest < ActsAsMarkupTestCase
  context 'acts_as_textile' do
    setup do
      @textile_text = "h2. Textile Test Text"
      class ::Post < ActiveRecord::Base
        acts_as_textile :body
      end
      @post = Post.create!(:title => 'Blah', :body => @textile_text)
    end
    
    should "have a RedCloth object returned for the column value" do
      assert_kind_of RedCloth::TextileDoc, @post.body
    end
  
    should "return original textile text for a `to_s` method call on the column value" do
      assert_equal @textile_text, @post.body.to_s
    end
    
    should 'return false for .blank?' do
      assert !@post.body.blank?
    end
  
    should "return formated html for a `to_html` method call on the column value" do
      assert_match(/<h2>Textile Test Text<\/h2>/, @post.body.to_html)
    end
    
    should "not return escaped html" do
      @post.body = "h2. Textile <i>Test</i> Text"
      assert_match(/<i>Test<\/i>/, @post.body.to_html)
    end
  
    context "changing value of textile field should return new textile object" do
      setup do
        @old_body = @post.body
        @post.body = "@@count = 20@"
      end
    
      should "still have an RedCloth object but not the same object" do
        assert_kind_of RedCloth::TextileDoc, @post.body
        assert_not_same @post.body, @old_body 
      end
    
      should "return correct text for `to_s`" do
        assert_equal "@@count = 20@", @post.body.to_s
      end
    
      should "return correct HTML for the `to_html` method" do
        assert_match(/<code>\@count\s\=\s20<\/code>/, @post.body.to_html)
      end
    
      teardown do
        @old_body = nil
      end
    end
    
    teardown do
      @textile_text, @post = nil
      Post.delete_all
    end
  end
  
  context 'acts_as_textile with options' do
    setup do
      class ::Post
        acts_as_textile :body, :textile_options => [ [ :filter_html ] ]
      end
      @post = Post.new(:title => 'Blah')
    end
    
    should "return escaped html because of :filter_html" do
      @post.body = "h2. Textile <i>Test</i> Text"
      assert_match(/&lt;i&gt;Test&lt;\/i&gt;/, @post.body.to_html)
    end
  end
end
