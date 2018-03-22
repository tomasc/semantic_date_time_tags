require 'action_view'

require_relative 'tag'
require_relative 'tag/date_range'
require_relative 'tag/date_time'
require_relative 'tag/date'
require_relative 'tag/time'

module SemanticDateTimeTags
  module ViewHelpers
    def self.included(klass)
      klass.class_eval do
        include ActionView::Context
      end
    end

    # accepts datetime and date
    def semantic_date_range_tag(date_from, date_to, options = {})
      SemanticDateTimeTags::Tag::DateRange.new(date_from, date_to, options).to_html
    end
    alias semantic_date_time_range_tag semantic_date_range_tag

    # accepts only datetime
    def semantic_date_time_tag(date_time, options = {})
      SemanticDateTimeTags::Tag::DateTime.new(date_time, options).to_html
    end

    # accepts datetime and date
    def semantic_date_tag(date, options = {})
      SemanticDateTimeTags::Tag::Date.new(date, options).to_html
    end

    # accepts datetime and time
    def semantic_time_tag(time, options = {})
      SemanticDateTimeTags::Tag::Time.new(time, options).to_html
    end
  end
end
