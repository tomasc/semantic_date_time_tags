require 'action_view'

require_relative 'tag'
require_relative 'tag/date_range'
require_relative 'tag/date_time'
require_relative 'tag/date'
require_relative 'tag/time'

module DateTimeTags
  module ViewHelpers

    def self.included klass
      klass.class_eval do
        include ActionView::Context
      end
    end

    # ---------------------------------------------------------------------
    # accepts datetime and date

    def date_range_tag date_from, date_to, options={}
      DateTimeTags::Tag::DateRange.new(date_from, date_to, options).to_html
    end

    # ---------------------------------------------------------------------

    # accepts only datetime
    def date_time_tag date_time, all_day=false, options={}
      DateTimeTags::Tag::DateTime.new(date_time, options).to_html
    end

    # ---------------------------------------------------------------------

    # accepts datetime and date
    def date_tag date, tag_name=:time, options={}
      DateTimeTags::Tag::Date.new(date, tag_name, options).to_html
    end

    # ---------------------------------------------------------------------

    # accepts datetime and time
    def time_tags time, tag_name=:time, options={}
      DateTimeTags::Tag::Time.new(time, tag_name, options).to_html
    end

    # ---------------------------------------------------------------------

  end
end