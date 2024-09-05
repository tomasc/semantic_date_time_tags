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

        value = SemanticDateTimeTags::FormatParser.new(format_string, localized_obj).to_html.html_safe

        time_tag(obj, options.except(*%i[format])) { value }.html_safe
      end

      private
        def scope
          "date_time.formats"
        end

        def localized_obj
          format_string = case format
          when Symbol then I18n.t(format, scope: scope, locale: I18n.locale)
          else format
          end
          I18n.l(obj, format: format_string)
        end
    end
  end
end
