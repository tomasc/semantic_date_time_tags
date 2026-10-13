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

        # Localizes with the format the parser reads. Given a symbol, `I18n.l`
        # picks `time.formats` for a DateTime (it responds to `sec`), which
        # put the hour where the parser expects the day. A missing format
        # still raises through `super`.
        def localized_obj
          format_string.nil? ? super : I18n.l(obj, format: format_string)
        end
    end
  end
end
