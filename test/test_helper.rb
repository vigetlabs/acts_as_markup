require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'active_support/version'
if ActiveSupport::VERSION::MAJOR >= 4
  require 'minitest/autorun'
else
  require 'test/unit'
end
gem 'sqlite3'
require 'shoulda'
require 'active_support'
require 'active_support/test_case'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'acts_as_markup'
require 'acts_as_markup/exts/string'
require 'acts_as_markup/stringlike'
require 'acts_as_markup/active_record_extension'
require 'active_record'

ActiveRecord::Schema.verbose = false
ActiveRecord::Base.send :include, ActsAsMarkup::ActiveRecordExtension
ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database => ":memory:")
ActsAsMarkup.markdown_library = :rdiscount

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
