require 'test/unit'
require 'shoulda'
require File.expand_path( File.join(File.dirname(__FILE__), %w[.. lib acts_as_markup]) )

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
  end
end

def teardown_db
  ActiveRecord::Base.connection.tables.each do |table|
    ActiveRecord::Base.connection.drop_table(table)
  end
end
