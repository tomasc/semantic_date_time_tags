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
      end

      # ---------------------------------------------------------------------

      def spans_years?
        return false if date_to.nil?
        date_from.year != date_to.year
      end

      def spans_months?
        date_from.month != date_to.month
      end

      def within_a_week?
        (date_from - date_to) <= 7
      end

      def same_day?
        date_from.to_date == date_to.to_date
      end

      def same_time?
        date_from.to_time == date_to.to_time
      end

      def both_in_current_year?
        return false if spans_years?
        date_from.year == ::Date.today.year
      end

      def same_meridian?
        return false unless same_day?
        (date_from.to_datetime.hour < 12 && date_to.to_datetime.hour < 12) ||
          (date_from.to_datetime.hour >= 12 && date_to.to_datetime.hour >= 12)
      end

      # ---------------------------------------------------------------------

      def dom_classes
        res = []
        res << 'date_range'
        res << 'same_year' unless spans_years?
        res << 'current_year' if both_in_current_year?
        res << 'same_month' unless spans_months?
        res << 'more_than_a_week' unless within_a_week?
        res << 'same_day' if same_day?
        res << 'same_time' if same_time?
        res << 'same_meridian' if same_meridian?
        res
      end

      # ---------------------------------------------------------------------

      def to_html
        from = case date_from
               when ::DateTime then SemanticDateTimeTags::Tag::DateTime.new(date_from, options.merge(class: 'from')).to_html
               when ::Date then SemanticDateTimeTags::Tag::Date.new(date_from.to_date, options.merge(class: 'from')).to_html
        end

        sep = content_tag(:span, separator, class: 'date_range_separator')

        to = case date_to
             when ::DateTime then SemanticDateTimeTags::Tag::DateTime.new(date_to, options.merge(class: 'to')).to_html
             when ::Date then SemanticDateTimeTags::Tag::Date.new(date_to.to_date, options.merge(class: 'to')).to_html
        end

        content_tag(:span, class: dom_classes) { [from, sep, to].join.html_safe }.html_safe
      end

      private # =============================================================

      def separator
        options.fetch(:separator, ' – ')
      end
    end
  end
end
