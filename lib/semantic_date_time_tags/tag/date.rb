require_relative '../format_parser'

module SemanticDateTimeTags
  class Tag
    class Date < Tag

      def initialize obj, options={}
        raise 'object must be Date or DateTime' unless [::Date, ::DateTime].any? { |c| obj.instance_of? c }
        super(obj, options)
      end

      # ---------------------------------------------------------------------

      def to_html
        if tag_name == :time
          datetime = obj.acts_like?(:time) ? obj.xmlschema : obj.iso8601
          options[:datetime] = datetime
        end

        options[:class] = dom_classes

        value = SemanticDateTimeTags::FormatParser.new(format_string, localized_obj).to_html.html_safe

        content_tag(tag_name, options) { value }.html_safe
      end

      private # =============================================================

      def scope
        'date.formats'
      end

    end
  end
end
