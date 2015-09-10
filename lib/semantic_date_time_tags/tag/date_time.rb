require_relative '../format_parser'

module SemanticDateTimeTags
  class Tag
    class DateTime < Tag

      def initialize obj, tag_name, options={}
        raise 'object must be DateTime' unless obj.instance_of?(::DateTime)
        super(obj, options)
      end

      # ---------------------------------------------------------------------

      def localized_obj
        @obj.strftime(I18n.t(:"date_time.formats.full", { locale: I18n.locale }))
      end

      # ---------------------------------------------------------------------

      def format
        translations.fetch(:date_time)[:formats][:full].to_s
      end

      # ---------------------------------------------------------------------

      def to_html
        if @tag_name == :time
          datetime = @obj.acts_like?(:time) ? @obj.xmlschema : @obj.iso8601
          @options[:datetime] = datetime
        end

        @options[:class] = dom_classes

        time_tag(@obj, @options) do
          SemanticDateTimeTags::FormatParser.new(format, localized_obj).to_html.html_safe
        end.html_safe
      end

    end
  end
end
