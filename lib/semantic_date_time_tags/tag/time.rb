require_relative '../format_parser'

module SemanticDateTimeTags
  class Tag
    class Time < Tag

      def initialize obj, tag_name, options={}
        raise 'object must be Time' unless obj.instance_of?(::Time)
        super(obj, tag_name, options)
      end

      # ---------------------------------------------------------------------

      def to_html
        if @tag_name == :time
          datetime = @obj.acts_like?(:time) ? @obj.xmlschema : @obj.iso8601
          @options[:datetime] = datetime
        end

        @options[:class] = dom_classes

        value = SemanticDateTimeTags::FormatParser.new(format_string, localized_obj).to_html

        content_tag(@tag_name, @options) { value }.html_safe
      end

      private # =============================================================

      def scope
        'time.formats'
      end

    end
  end
end
