# frozen_string_literal: true

require "action_view"
require "i18n"

module SemanticDateTimeTags
  class Tag
    include ActionView::Helpers::DateHelper
    include ActionView::Helpers::TagHelper

    attr_accessor :obj
    attr_accessor :options
    attr_accessor :output_buffer

    def initialize(obj, options = {})
      @obj = obj
      @options = options.except(*%i(scope))
    end

    def to_html
      raise NotImplementedError
    end

    def dom_classes
      [
        "semantic",
        locale_class,
        am_pm_class,
        type_class,
        current_date_class,
        current_year_class,
        midnight_class,
        noon_class,
        whole_hour_class,
        whole_minute_class,
        options[:class]
      ].flatten.reject(&:blank?)
    end

    def type_class
      obj.class.to_s.underscore
    end

    def current_date_class
      return unless [::Date, ::DateTime].any? { |c| obj.instance_of? c }
      "current_date" if obj.today?
    end

    def current_year_class
      return unless [::Date, ::DateTime].any? { |c| obj.instance_of? c }
      "current_year" if obj.year == ::Date.today.year
    end

    def whole_hour_class
      return unless [::Time, ::DateTime].any? { |c| obj.instance_of? c }
      "whole_hour" unless obj.min > 0
    end

    def whole_minute_class
      return unless [::Time, ::DateTime].any? { |c| obj.instance_of? c }
      "whole_minute" unless obj.sec > 0
    end

    def noon_class
      return unless [::Time, ::DateTime].any? { |c| obj.instance_of? c }
      "noon" if obj == obj.noon
    end

    def midnight_class
      return unless [::Time, ::DateTime].any? { |c| obj.instance_of? c }
      "midnight" if obj == obj.midnight
    end

    def am_pm_class
      return unless [::Time, ::DateTime].any? { |c| obj.instance_of? c }
      case
      when (0..11).cover?(obj.hour) then "am"
      else "pm"
      end
    end

    def locale_class
      I18n.locale.to_s
    end

    def dom_data
      { in_words: in_words, format: format.to_s }
    end

    private
      def scope
        raise NotImplementedError
      end

      def format_string
        case format
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
        [noon_in_words, midnight_in_words].reject(&:blank?).join(" ")
      end

      def noon_in_words
        return unless [::Time, ::DateTime].any? { |c| obj.instance_of? c }
        return unless obj == obj.noon
        I18n.t :noon, scope: %i(time in_words)
      end

      def midnight_in_words
        return unless [::Time, ::DateTime].any? { |c| obj.instance_of? c }
        return unless obj == obj.midnight
        I18n.t :midnight, scope: %i(time in_words)
      end
  end
end
