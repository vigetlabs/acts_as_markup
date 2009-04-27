require 'test/unit'
require 'rubygems'
gem 'sqlite3-ruby'
require 'shoulda'
require 'active_support'
require 'active_support/test_case'
require File.expand_path( File.join(File.dirname(__FILE__), %w[.. lib acts_as_markup]) )
ActiveRecord::Schema.verbose = false

ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :dbfile => ":memory:")

def setup_db
  ActiveRecord::Schema.define(:version => 1) do
    create_table :posts do |t|
      t.column :title, :string
      t.column :body, :text
      t.timestamps
    end
    
    create_table :markdown_posts do |t|
      t.column :title, :string
      t.column :body, :text
      t.timestamps
    end
    
    create_table :textile_posts do |t|
      t.column :title, :string
      t.column :body, :text
      t.timestamps
    end
    
    create_table :variable_posts do |t|
      t.column :title, :string
      t.column :body, :text
      t.column :markup_language, :string
      t.timestamps
    end
    
    create_table :variable_language_posts do |t|
      t.column :title, :string
      t.column :body, :text
      t.column :language_name, :string
      t.timestamps
    end
  end
end

def teardown_db
  ActiveRecord::Base.connection.tables.each do |table|
    ActiveRecord::Base.connection.drop_table(table)
  end
end

class ActsAsMarkupTestCase < ActiveSupport::TestCase
  def setup
    setup_db
  end
  
  def teardown
    teardown_db
  end
  
  def self.should_act_like_a_string
    should "act like a string" do
      assert_equal @post.body.split(' '), ['##', 'Markdown', 'Test', 'Text']
      assert @post.body.match(/Te[sx]t/)
    end
  end
end
