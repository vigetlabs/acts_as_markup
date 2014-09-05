module ActsAsMarkup
  class Railtie < Rails::Railtie
    config.acts_as_markup = ActiveSupport::OrderedOptions.new
    
    initializer 'acts_as_markup.set_config', :after => 'active_record.initialize_database' do |app|
      ActiveSupport.on_load(:acts_as_markup) do
        self.markdown_library = app.config.acts_as_markup.markdown_library
      end
    end
    
    initializer 'acts_as_markup.extend_active_record', :after => 'acts_as_markup.set_config' do |app|
      ActiveSupport.on_load(:active_record) do
        require 'acts_as_markup/exts/string'
        require 'acts_as_markup/stringlike'
        require 'acts_as_markup/active_record_extension'
        self.send :include, ActsAsMarkup::ActiveRecordExtension
      end
    end
    
    config.before_configuration do
      config.acts_as_markup['markdown_library'] ||= :rdiscount
    end
  end
end
