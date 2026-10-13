# frozen_string_literal: true

module SemanticDateTimeTags
  class Tag
    class Date < Tag
      def initialize(obj, options = {})
        raise "object must be Date or DateTime" unless obj.instance_of?(::Date) || obj.instance_of?(::DateTime)

        options = options.except(*%i[separator])

        super(obj, options)
      end

      def to_html
        if tag_name == :time
          datetime = obj.acts_like?(:time) ? obj.xmlschema : obj.iso8601
          options[:datetime] = datetime
        end

        options[:class] = dom_classes
        options[:data] = dom_data
        options.merge!(aria_attributes)

        value = SemanticDateTimeTags::FormatParser.new(format_string, localized_obj).to_html

        content_tag(tag_name, options.except(*%i[format aria aria_label])) { value }
      end

      private
        def scope
          "date.formats"
        end
    end
  end
end
