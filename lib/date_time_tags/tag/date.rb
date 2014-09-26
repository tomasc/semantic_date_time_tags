require_relative '../format_parser'

module DateTimeTags
  class Tag
    class Date < Tag

      def initialize obj, tag_name, options={}
        raise 'object must be Date or DateTime' unless [::Date, ::DateTime].any? { |c| obj.instance_of? c }
        super(obj, tag_name, options)
      end

      # ---------------------------------------------------------------------

      def format
        translations.fetch(:date)[:formats][:full].to_s
      end

      # ---------------------------------------------------------------------

      def to_html
        if @tag_name == :time
          datetime = @obj.acts_like?(:time) ? @obj.xmlschema : @obj.iso8601
          @options[:datetime] = datetime
        end

        content_tag(@tag_name, { class: dom_classes }, @options) do
          DateTimeTags::FormatParser.new(format, localized_obj).to_html.html_safe
        end.html_safe
      end

    end
  end
end