# frozen_string_literal: true

module SemanticDateTimeTags
  class Tag
    class DateTime < Tag
      def initialize(obj, options = {})
        raise "object must be DateTime" unless obj.instance_of?(::DateTime)

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

        # What `time_tag` renders, without the `I18n.l(obj, format: :long)` it
        # computes as content and then discards for the block.
        content_tag(:time, options.except(*%i[format aria aria_label]).reverse_merge(datetime: obj.iso8601)) { value }
      end

      private
        def scope
          "date_time.formats"
        end

        # Reuses the format `format_string` already looked up. A missing one
        # goes through `I18n.t` as before, so a raising exception handler
        # still raises for it.
        def localized_obj
          return I18n.l(obj, format: format_string) unless format_string.nil?

          missing = format.is_a?(Symbol) ? I18n.t(format, scope: scope, locale: I18n.locale) : format
          I18n.l(obj, format: missing)
        end
    end
  end
end
