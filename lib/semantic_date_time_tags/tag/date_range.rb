# frozen_string_literal: true

module SemanticDateTimeTags
  class Tag
    class DateRange < Tag
      attr_accessor :date_from
      attr_accessor :date_to
      attr_accessor :options

      def initialize(date_from, date_to = nil, options = {})
        @date_from = date_from
        @date_to = date_to
        @options = options
        @separator = options.delete(:separator) || " – "
      end

      def spans_years?
        return false if date_to.nil?
        date_from.year != date_to.year
      end

      def spans_months?
        return false if date_to.nil?
        date_from.month != date_to.month
      end

      def within_a_week?
        return true if date_to.nil?
        (date_from - date_to) <= 7
      end

      def same_day?
        return true if date_to.nil?
        date_from.to_date == date_to.to_date
      end

      def same_time?
        return true if date_to.nil?
        # Compare times without timezone conversion to avoid deprecation warning
        date_from_time = date_from.respond_to?(:hour) ? [date_from.hour, date_from.min, date_from.sec] : [0, 0, 0]
        date_to_time = date_to.respond_to?(:hour) ? [date_to.hour, date_to.min, date_to.sec] : [0, 0, 0]
        date_from_time == date_to_time
      end

      def both_in_current_year?
        return false if spans_years?
        date_from.year == ::Date.today.year
      end

      def same_meridian?
        return true if date_to.nil?
        return false unless same_day?
        (date_from.to_datetime.hour < 12 && date_to.to_datetime.hour < 12) ||
          (date_from.to_datetime.hour >= 12 && date_to.to_datetime.hour >= 12)
      end

      def dom_classes
        res = []
        res << "date_range"
        res << "same_year" unless spans_years?
        res << "current_year" if both_in_current_year?
        res << "same_month" unless spans_months?
        res << "more_than_a_week" unless within_a_week?
        res << "same_day" if same_day?
        res << "same_time" if same_time?
        res << "same_meridian" if same_meridian?
        res
      end

      def dom_data
        options.fetch(:data, {})
      end

      def aria_attributes
        aria_options = options.fetch(:aria, {})
        
        # Add automatic aria-label if not provided
        if aria_options[:label].nil? && options[:aria_label] != false
          aria_options[:label] = automatic_aria_label
        end
        
        # Convert aria hash to aria-* attributes
        aria_options.transform_keys { |key| "aria-#{key}".to_sym }
      end

      def automatic_aria_label
        from_str = date_from.strftime('%B %-d, %Y')
        to_str = date_to.strftime('%B %-d, %Y') if date_to
        
        if date_to
          "Date range: #{from_str} to #{to_str}"
        else
          "Date range starting: #{from_str}"
        end
      end

      def to_html
        from_options = options.merge(class: "from").except(:data, :time_data).merge(data: options.fetch(:time_data, {}))
        from = case date_from
        when ::DateTime then SemanticDateTimeTags::Tag::DateTime.new(date_from, from_options).to_html
        when ::Date then SemanticDateTimeTags::Tag::Date.new(date_from.to_date, from_options).to_html
        end

        if date_to
          sep = content_tag(:span, @separator, class: "date_range_separator")

          to_options = options.merge(class: "to").except(:data, :time_data).merge(data: options.fetch(:time_data, {}))
          to = case date_to
          when ::DateTime then SemanticDateTimeTags::Tag::DateTime.new(date_to, to_options).to_html
          when ::Date then SemanticDateTimeTags::Tag::Date.new(date_to.to_date, to_options).to_html
          end
        end

        tag_options = { class: dom_classes, data: dom_data }
        tag_options.merge!(aria_attributes)
        tag_options = tag_options.except(:aria, :aria_label)
        
        elements = date_to ? [ from, sep, to ] : [ from ]
        content_tag(:span, tag_options) { elements.join.html_safe }.html_safe
      end
    end
  end
end
