require "i18n"
require "date_time_tags/railtie" if defined?(Rails)
require "date_time_tags/engine"
require "date_time_tags/version"

I18n.load_path += Dir.glob(File.join( File.dirname(__FILE__), 'config', 'locales', '*.yml' ))