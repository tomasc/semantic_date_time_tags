require_relative '../format_parser'

module SemanticDateTimeTags
  class Tag
    class DateTime < Tag

      def initialize obj, options={}
        raise 'object must be DateTime' unless obj.instance_of?(::DateTime)
        super(obj, :time, options)
      end

      # ---------------------------------------------------------------------

      def to_html
        if @tag_name == :time
          datetime = @obj.acts_like?(:time) ? @obj.xmlschema : @obj.iso8601
          @options[:datetime] = datetime
        end

        @options[:class] = dom_classes

        value = SemanticDateTimeTags::FormatParser.new(format_string, localized_obj).to_html.html_safe

        time_tag(@obj, @options) { value }.html_safe
      end

      private # =============================================================

      def scope
        'date_time.formats'
      end

      def localized_obj
        @obj.strftime I18n.t( format, scope: scope, locale: I18n.locale )
      end

    end
  end
end
