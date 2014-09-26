require 'action_view'
require 'i18n'

module DateTimeTags
  class Tag

    include ActionView::Helpers::DateHelper
    include ActionView::Helpers::TagHelper

    # =====================================================================

    attr_accessor :output_buffer

    def initialize obj, tag_name, options={}
      @obj = obj
      @tag_name = tag_name
      @options = options
    end

    def to_html
      raise 'Should be implemented by a subclass'
    end

    # ---------------------------------------------------------------------

    def translations
      I18n.backend.send(:translations)[I18n.locale]
    end

    # ---------------------------------------------------------------------

    def localized_obj
      I18n.l(@obj, format: :full)
    end

    # ---------------------------------------------------------------------

    def dom_classes
      [
        type_class,
        current_date_class,
        current_year_class,
        whole_hour_class,
        whole_minute_class,
        @options[:class]
      ].reject(&:blank?)
    end

    def type_class
      @obj.class.to_s.underscore
    end

    def current_date_class
      return unless [::Date,::DateTime].any? {|c| @obj.instance_of? c}
      'current_date' if @obj.today?
    end

    def current_year_class
      return unless [::Date,::DateTime].any? {|c| @obj.instance_of? c}
      'current_year' if @obj.year == ::Date.today.year
    end

    def whole_hour_class
      return unless [::Time,::DateTime].any? {|c| @obj.instance_of? c}
      'whole_hour' unless @obj.min > 0
    end

    def whole_minute_class
      return unless [::Time,::DateTime].any? {|c| @obj.instance_of? c}
      'whole_minute' unless @obj.sec > 0
    end

  end
end
