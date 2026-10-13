# encoding: utf-8
# frozen_string_literal: true

require "action_view/helpers/tag_helper"

module SemanticDateTimeTags
  class FormatParser < Struct.new(:format, :str)
    include ActionView::Helpers::TagHelper

    # Each format's compiled components — `[regexp, opening tag]` pairs — keyed
    # by the format string and capped, so formats built at runtime (an
    # interpolated venue name, say) cannot grow it for the life of the process.
    FORMAT_COMPONENTS_CACHE = {}

    STR_OPEN_TAG = %(<span class="str">)
    CLOSE_TAG = "</span>"

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

      # The spans are concatenated rather than built with `content_tag`: the
      # opening tag is precomputed per component, so only the matched text is
      # escaped per render (#3094 in tomasc/modulor).
      html = +""
      offset = 0

      components.each do |regexp, open_tag|
        # Pass offset to Regexp#match instead of slicing str[offset..-1] —
        # slicing allocates a new String per iteration; matching with an
        # offset starts at that position in place.
        if match = regexp.match(str, offset)
          append_span(html, open_tag, match[1])
          offset = match.end(0)
        end
      end

      # Add any remaining string
      if offset < str.length
        rest = str[offset..]
        append_span(html, STR_OPEN_TAG, rest) if rest.present?
      end

      html.html_safe
    end

    private
      def formatting_components
        return unless format.present?

        # Use cached components if available
        cached = FORMAT_COMPONENTS_CACHE[format]
        return cached if cached

        # Parse, compile and cache the components
        components = format.scan(/(%-?[[:word:]]|.+?(?=%))/).flatten.map do |comp|
          [ Regexp.new(get_regexp_for_component(comp)), open_tag_for_component(comp) ].freeze
        end.freeze

        # Limit cache size to prevent memory bloat
        if FORMAT_COMPONENTS_CACHE.size >= MAX_FORMAT_CACHE_SIZE
          # Remove oldest entries (simple FIFO)
          FORMAT_COMPONENTS_CACHE.shift
        end

        FORMAT_COMPONENTS_CACHE[format] = components
        components
      end

      # Escapes exactly as `content_tag` does: html_safe text passes through.
      def append_span(html, open_tag, text)
        html << open_tag << ERB::Util.unwrapped_html_escape(text) << CLOSE_TAG
      end

      def open_tag_for_component(comp)
        classes = get_classes_for_component(comp)
        classes ? %(<span class="#{ERB::Util.html_escape(classes.join(" "))}">).freeze : "<span>"
      end

      def get_regexp_for_component(comp)
        COMPONENT_PATTERNS.each do |pattern, regex|
          return regex.source if comp.match?(pattern)
        end
        "(#{Regexp.escape(comp)})"
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
