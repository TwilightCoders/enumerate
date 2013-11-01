module UrlFormatter
  class Railtie < Rails::Railtie
    initializer 'enumerate.model' do
      ActiveSupport.on_load :active_record do
        extend Enumerate::Model
      end
    end
  end
end