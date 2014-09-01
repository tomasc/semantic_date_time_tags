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
      I18n.backend.send(:translations)[I18n.locale]
    end

    # ---------------------------------------------------------------------

    def date_format
      translations.fetch(:date)[:formats][:full].to_s
    end

    def date_range_tag date_from, date_to, options={}
      date_range = DateRange.new(date_from, date_to)
      separator = options.fetch(:separator, ' – ')
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

    def date_time_tag date_time, all_day=false, options={}
      return unless [Time,DateTime].any? {|c| date_time.instance_of? c}
      time_tag(date_time, { class: [dom_classes(date_time), options[:class]].reject(&:blank?).join(' ') }) do
        [
          date_tag(date_time.to_date, :span, options),
          content_tag(:span, separator, class: 'date_time_separator'),
          time_tags(date_time, :span)
        ].join.html_safe
      end
    end

    # ---------------------------------------------------------------------

    def date_tag date, tag_name=:time, options={}
      return unless [Date, DateTime].any? { |c| date.instance_of? c }
      localized_date = I18n.l(date, format: :full)
      if tag_name == :time
        datetime = date.acts_like?(:time) ? date.xmlschema : date.iso8601
        options[:datetime] = datetime
      end
      content_tag(tag_name, { class: [dom_classes(date), options[:class]].reject(&:blank?).join(' ') }) do
        markup_localized_date_or_time_string(localized_date, date_format).html_safe
      end.html_safe
    end

    # ---------------------------------------------------------------------

    def time_format
      translations.fetch(:time, {}[:formats][:full]).to_s
    end

    def time_tags time, tag_name=:time
      return unless [Time, DateTime].any? { |c| time.instance_of? c }
      return unless time_format.present?
      localized_time = I18n.l(time, format: :full)
      content_tag(tag_name, class: time_classes(time)) do
        markup_localized_date_or_time_string(localized_time, time_format).html_safe
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

    def dom_classes date_or_time
      DomClasses.new(date_or_time).to_s
    end

    # ---------------------------------------------------------------------

    class DomClasses

      def initialize date_or_time
        @date_or_time = date_or_time
        @res = []

        @res << type_class
        @res << current_date_class
        @res << current_year_class
        @res << whole_hour_class
        @res << whole_minute_class
      end

      def to_s
        @res.reject(&:blank?).join(' ')
      end

      def type_class
        @date_or_time.class.to_s.underscore
      end

      def current_date_class
        return unless [Date,DateTime].any? {|c| @date_or_time.instance_of? c}
        'current_date' if @date_or_time.today?
      end

      def current_year_class
        return unless [Date,DateTime].any? {|c| @date_or_time.instance_of? c}
        'current_year' if @date_or_time.year == Date.today.year
      end

      def whole_hour_class
        return unless [Time,DateTime].any? {|c| @date_or_time.instance_of? c}
        'whole_hour' unless @date_or_time.min > 0
      end

      def whole_minute_class
        return unless [Time,DateTime].any? {|c| @date_or_time.instance_of? c}
        'whole_minute' unless @date_or_time.sec > 0
      end
    end

    # ---------------------------------------------------------------------

  end
end