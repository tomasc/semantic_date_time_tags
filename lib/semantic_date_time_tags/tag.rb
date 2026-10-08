# frozen_string_literal: true

module SemanticDateTimeTags
  class Tag
    include ActionView::Helpers::DateHelper
    include ActionView::Helpers::TagHelper

    attr_accessor :obj
    attr_accessor :options
    attr_accessor :output_buffer
    attr_writer :today, :current_date

    TYPE_CLASS_CACHE = {}

    def initialize(obj, options = {})
      @obj = obj
      @options = options.except(*%i[scope])
    end

    def to_html
      raise NotImplementedError
    end

    def dom_classes
      @dom_classes ||= begin
        classes = [
          "semantic",
          locale_class,
          am_pm_class,
          type_class,
          current_date_class,
          current_year_class,
          midnight_class,
          noon_class,
          whole_hour_class,
          whole_minute_class
        ]
        classes.compact!
        # Only the caller's classes can be blank: `blank?` is a regexp match
        # per string, so the generated ones skip it.
        classes.concat([ options[:class] ].flatten.reject(&:blank?)) unless options[:class].nil?
        classes
      end
    end

    def type_class
      TYPE_CLASS_CACHE[obj.class] ||= obj.class.to_s.underscore.freeze
    end

    # Read once per tag, and handed down by a range to the tags it renders,
    # so one render reads the clock once. `today` is the system date and
    # `current_date` the application time zone's, which `Date#today?` reads.
    def today
      @today ||= ::Date.today
    end

    def current_date
      @current_date ||= ::Date.current
    end

    def current_date_class
      return unless date_like?
      "current_date" if obj.to_date == current_date
    end

    def current_year_class
      return unless date_like?
      "current_year" if obj.year == today.year
    end

    def whole_hour_class
      return unless time_like?
      "whole_hour" unless obj.min > 0
    end

    def whole_minute_class
      return unless time_like?
      "whole_minute" unless obj.sec > 0
    end

    def noon_class
      "noon" if noon?
    end

    def midnight_class
      "midnight" if midnight?
    end

    def am_pm_class
      return unless time_like?
      case
      when (0..11).cover?(obj.hour) then "am"
      else "pm"
      end
    end

    def locale_class
      I18n.locale.to_s
    end

    def dom_data
      options.fetch(:data, {})
        .merge(in_words: in_words, format: format.to_s)
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

    private
      def scope
        raise NotImplementedError
      end

      def format_string
        return @format_string if defined?(@format_string)
        @format_string = case format
        when Symbol then I18n.t(scope)[format]
        else format
        end
      end

      def format
        options.fetch :format, :full
      end

      def localized_obj
        I18n.l obj, format: format
      end

      def tag_name
        options.fetch :tag_name, :time
      end

      def in_words
        [ noon_in_words, midnight_in_words ].reject(&:blank?).join(" ")
      end

      def noon_in_words
        return unless noon?
        I18n.t :noon, scope: %i[time in_words]
      end

      def midnight_in_words
        return unless midnight?
        I18n.t :midnight, scope: %i[time in_words]
      end

      def date_like?
        obj.instance_of?(::Date) || obj.instance_of?(::DateTime)
      end

      def time_like?
        obj.instance_of?(::Time) || obj.instance_of?(::DateTime)
      end

      # Each comparison builds a new object (`obj.noon` is a `change`), and
      # both the class and the in-words text ask.
      def noon?
        return @noon if defined?(@noon)
        @noon = time_like? && obj == obj.noon
      end

      def midnight?
        return @midnight if defined?(@midnight)
        @midnight = time_like? && obj == obj.midnight
      end

      def automatic_aria_label
        # Generate a descriptive aria-label based on the date/time
        case obj
        when ::DateTime
          time_part = obj.strftime("%-l:%M %p")
          "Date and time: #{obj.strftime('%A, %B %-d, %Y')} at #{time_part}"
        when ::Date
          "Date: #{obj.strftime('%A, %B %-d, %Y')}"
        when ::Time
          "Time: #{obj.strftime('%-l:%M %p')}"
        else
          nil
        end
      end
  end
end
