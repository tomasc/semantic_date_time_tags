require_relative '../format_parser'

module DateTimeTags
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
        time_tag(@obj, { class: dom_classes }) do
          DateTimeTags::FormatParser.new(format, localized_obj).to_html.html_safe
        end.html_safe
      end

    end
  end
end