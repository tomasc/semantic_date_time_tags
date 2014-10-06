require 'semantic_date_time_tags/view_helpers'

module SemanticDateTimeTags
  class Railtie < Rails::Railtie
    initializer "semantic_date_time_tags.view_helpers" do
      ActionView::Base.send :include, ViewHelpers
    end
  end
end