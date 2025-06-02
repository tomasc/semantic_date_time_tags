# encoding: utf-8
# frozen_string_literal: true

require "action_view/helpers/tag_helper"

module SemanticDateTimeTags
  class FormatParser < Struct.new(:format, :str)
    include ActionView::Helpers::TagHelper

    # Class-level caches
    COMPONENT_REGEX_CACHE = {}
    COMPONENT_CLASSES_CACHE = {}
    FORMAT_COMPONENTS_CACHE = {}

    # Pre-compiled regex patterns for common components
    COMPONENT_PATTERNS = {
      /%-?[ekl]/ => /\s?([[:word:]]+)/,
      /%-?[[:word:]]/ => /([[:word:]]+)/
    }.freeze

    # Common date/time formats cache limit
    MAX_FORMAT_CACHE_SIZE = 100

    def to_html
      return "" unless str.present?
      components = formatting_components
      return "" unless components.present?

      html_parts = []
      offset = 0

      components.flatten.each do |comp|
        regexp = get_cached_regexp_for_component(comp)
        if match = str[offset..-1].match(regexp)
          html_parts << get_tag_for_match(match[1], comp)
          offset += match.end(0)
        end
      end

      # Add any remaining string
      if offset < str.length
        html_parts << get_tag_for_str(str[offset..-1])
      end

      html_parts.join.html_safe
    end

    private
      def formatting_components
        return unless format.present?

        # Use cached components if available
        cached = FORMAT_COMPONENTS_CACHE[format]
        return cached if cached

        # Parse and cache the components
        components = format.scan(/(%-?[[:word:]]|.+?(?=%))/)

        # Limit cache size to prevent memory bloat
        if FORMAT_COMPONENTS_CACHE.size >= MAX_FORMAT_CACHE_SIZE
          # Remove oldest entries (simple FIFO)
          FORMAT_COMPONENTS_CACHE.shift
        end

        FORMAT_COMPONENTS_CACHE[format] = components
        components
      end

      def get_tag_for_match(match, comp)
        content_tag :span, match, class: get_cached_classes_for_component(comp)
      end

      def get_tag_for_str(str)
        return "" unless str.present?
        content_tag :span, str, class: "str"
      end

      def get_cached_regexp_for_component(comp)
        COMPONENT_REGEX_CACHE[comp] ||= Regexp.new(get_regexp_for_component(comp))
      end

      def get_regexp_for_component(comp)
        COMPONENT_PATTERNS.each do |pattern, regex|
          return regex.source if comp.match?(pattern)
        end
        "(#{Regexp.escape(comp)})"
      end

      def get_cached_classes_for_component(comp)
        COMPONENT_CLASSES_CACHE[comp] ||= get_classes_for_component(comp)
      end

      def get_classes_for_component(comp)
        case comp
        when /%-?[YCy]/ then [ "year", comp[/[[:word:]]/] ]
        when /%-?[mBbh]/ then [ "month", comp[/[[:word:]]/] ]
        when /%-?[aAdej]/ then [ "day", comp[/[[:word:]]/] ]
        when /%-?[HkKIl]/ then [ "hours", comp[/[[:word:]]/] ]
        when /%-?[M]/ then [ "minutes", comp[/[[:word:]]/] ]
        when /%-?[pP]/ then [ "ampm", comp[/[[:word:]]/] ]
        when /%-?[Ss]/ then [ "seconds", comp[/[[:word:]]/] ]
        when /%-?[L]/ then [ "milliseconds", comp[/[[:word:]]/] ]
        when /\W+/ then [ "sep" ]
        end
      end
  end
end
