module SemanticDateTimeTags
  class Tag
    class DateRange < Tag

      def initialize date_from, date_to=nil, options={}
        @date_from = date_from
        @date_to = date_to
        @options = options
      end

      # ---------------------------------------------------------------------

      def spans_years?
        return false if @date_to.nil?
        @date_from.year != @date_to.year
      end

      def spans_months?
        @date_from.month != @date_to.month
      end

      def within_a_week?
        (@date_from - @date_to) <= 7
      end

      def one_day?
        @date_from == @date_to
      end

      # ---------------------------------------------------------------------

      def dom_classes
        res = []
        res << 'date_range'
        res << 'same_year' unless spans_years?
        res << 'same_month' unless spans_months?
        res << 'more_than_a_week' unless within_a_week?
        res << 'same_day' if one_day?
        res
      end

      # ---------------------------------------------------------------------

      def to_html
        from = SemanticDateTimeTags::Tag::Date.new(@date_from, :time, class: 'from').to_html
        sep = content_tag(:span, separator, class: 'date_range_separator')
        to = SemanticDateTimeTags::Tag::Date.new(@date_to, :time, class: 'to').to_html

        content_tag(:span, class: dom_classes) { [ from, sep, to ].join.html_safe }.html_safe
      end

      private # =============================================================

      def separator
        @options.fetch(:separator, ' – ')
      end

    end
  end
end
