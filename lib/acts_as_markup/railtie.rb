module ActsAsMarkup
  class Railtie < Rails::Railtie
    config.acts_as_markup = ActiveSupport::OrderedOptions.new
    
    initializer 'acts_as_markup.set_config', :after => 'active_record.initialize_database' do |app|
      ActiveSupport.on_load(:acts_as_markup) do
        self.markdown_library = app.config.acts_as_markup.markdown_library
        self.mediawiki_library = app.config.acts_as_markup.mediawiki_library
      end
    end
    
    initializer 'acts_as_markup.extend_active_record', :after => 'acts_as_markup.set_config' do |app|
      ActiveSupport.on_load(:active_record) do
        require 'acts_as_markup/exts/object'
        require 'acts_as_markup/stringlike'
        require 'acts_as_markup/active_record_extension'
        self.send :include, ActsAsMakup::ActiveRecordExtension
      end
    end
    
    config.before_configuration do
      config.acts_as_markup.markdown_library = :rdiscount
      config.acts_as_markup.mediawiki_library = :wikicloth
    end
  end
end
