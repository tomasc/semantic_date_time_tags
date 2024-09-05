# frozen_string_literal: true

module SemanticDateTimeTags
  class Tag
    class Date < Tag
      def initialize(obj, options = {})
        raise "object must be Date or DateTime" unless [ ::Date, ::DateTime ].any? { |c| obj.instance_of? c }

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

        content_tag(tag_name, options.except(*%i[format])) { value }.html_safe
      end

      private
        def scope
          "date.formats"
        end
    end
  end
end
