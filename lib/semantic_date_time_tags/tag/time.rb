# frozen_string_literal: true

module SemanticDateTimeTags
  class Tag
    class Time < Tag
      def initialize(obj, options = {})
        raise "object must be Time" unless obj.instance_of?(::Time)
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
          "time.formats"
        end

        # `I18n.l` resolves a symbol through the same `time.formats` key, so
        # reuse the lookup; a missing one still raises through `super`.
        def localized_obj
          format_string.nil? ? super : I18n.l(obj, format: format_string)
        end
    end
  end
end
