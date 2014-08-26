require 'date_time_tags/view_helpers'

module DateTimeTags
  class Railtie < Rails::Railtie
    initializer "date_time_tags.view_helpers" do
      ActionView::Base.send :include, ViewHelpers
    end
  end
end