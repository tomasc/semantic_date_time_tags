require 'action_view'

require_relative 'date_range'

module DateTimeTags
  module ViewHelpers

    def self.included klass
      klass.class_eval do
        include ActionView::Context
      end
    end

    # ---------------------------------------------------------------------

    def translations
      I18n.backend.send(:init_translations) unless I18n.backend.initialized?
      I18n.backend.send(:translations)[I18n.locale]
    end

    # ---------------------------------------------------------------------

    def date_range_tag date_from, date_to
      date_range = DateRange.new(date_from, date_to)
      separator = translations[:date_range][:separator].to_s
      content_tag(:span, class: [
        'date_range',
        ('same_year' unless date_range.spans_years?),
        ('same_month' unless date_range.spans_months?),
        ('more_than_a_week' unless date_range.within_a_week?),
        ('same_day' if date_range.one_day?)
      ]) do
        [
          date_tag(date_from, 'from'),
          content_tag(:span, separator, class: 'date_range_separator'),
          date_tag(date_to, 'to')
        ].join.html_safe
      end.html_safe
    end

    # ---------------------------------------------------------------------

    def date_time_tag date_time, all_day=false, cls=nil
      return unless [Time,DateTime].any? {|c| date_time.instance_of? c}
      separator = translations[:date_time][:separator].to_s
      time_tag(date_time, class: date_classes(date_time, cls, 'date_time')) do
        [
          date_tag(date_time.to_date, cls, :span),
          content_tag(:span, separator, class: 'date_time_separator'),
          time_tags(date_time, :span)
        ].join.html_safe
      end
    end

    # ---------------------------------------------------------------------

    def date_tag date, cls=nil, tag_name=:time
      return unless [Date,DateTime].any? {|c| date.instance_of? c}
      format = translations[:date][:formats][:full_date].to_s
      localized_date = I18n.l(date, format: :full_date)
      options = { class: date_classes(date, cls, 'date') }
      if tag_name == :time
        datetime = date.acts_like?(:time) ? date.xmlschema : date.iso8601
        options[:datetime] = datetime
      end
      content_tag(tag_name, options) do
        markup_localized_date_or_time_string(localized_date, format).html_safe
      end.html_safe
    end

    # ---------------------------------------------------------------------

    def time_tags time, tag_name=:time
      return unless [Time,DateTime].any? {|c| time.instance_of? c}
      format = translations[:time][:formats][:full_time].to_s
      separator = translations[:time][:separator].to_s
      localized_time = I18n.l(time, format: :full_time)
      content_tag(tag_name, class: time_classes(time)) do
        markup_localized_date_or_time_string(localized_time, format).html_safe
      end.html_safe
    end

    # ---------------------------------------------------------------------

    def markup_localized_date_or_time_string date_or_time, format
      values = format.scan( /(%-?\w)(\s*)([^%]?)?(\s*)/ )
      regexp_array = values.map do |value|
        group_name = get_name_from_strftime_directive(value[0])
        [
          "(?<#{group_name}>\\w+)",
          ("(?<space_#{group_name}_before>#{value[1]})" if !value[1].nil? && value[1].length > 0),
          ("(?<sep_#{group_name}>#{value[2]})" if !value[2].nil? && value[2].length > 0),
          ("(?<space_#{group_name}_after>#{value[3]})" if !value[3].nil? && value[3].length > 0)
        ]
      end
      regexp = Regexp.new(regexp_array.join)
      match = date_or_time.to_s.match(regexp)
      match.names.collect do |name|
        if name =~ /space/
          match[name]
        else
          content_tag(:span, match[name], class: name)
        end
      end.join
    end

    def get_name_from_strftime_directive directive
      case directive[/\w/]
      when 'Y', 'C', 'y' then 'year'
      when 'm', 'B', 'b', 'h' then 'month'
      when 'd', 'e', 'j' then 'day'
      when 'H', 'k', 'I', 'l' then 'hours'
      when 'M' then 'minutes'
      else 'unknown'
      end
    end

    # ---------------------------------------------------------------------

    def date_classes date, cls, type
      classes = [type]
      classes.push cls unless cls.nil?
      classes.push 'current_date' if date.today?
      classes.push 'current_year' if date.year == Date.today.year
      classes
    end

    def time_classes time
      classes = ['time']
      classes.push 'whole_hour' unless time.min > 0
      classes.push 'whole_minute' unless time.sec > 0
      classes
    end

    # ---------------------------------------------------------------------

  end
end