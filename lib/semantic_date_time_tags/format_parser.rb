# encoding: utf-8
# frozen_string_literal: true

require "active_support/core_ext/string/output_safety"

module SemanticDateTimeTags
  class FormatParser < Struct.new(:format, :str)
    # Class-level caches
    COMPONENT_REGEX_CACHE = {}
    COMPONENT_CLASSES_CACHE = {}
    COMPONENT_OPEN_TAG_CACHE = {}
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

      components.each do |comp|
        regexp = get_cached_regexp_for_component(comp)
        # Pass offset to Regexp#match instead of slicing str[offset..-1] —
        # slicing allocates a new String per iteration; matching with an
        # offset starts at that position in place.
        if match = regexp.match(str, offset)
          append_span(html, get_cached_open_tag_for_component(comp), match[1])
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

        # Parse and cache the components
        components = format.scan(/(%-?[[:word:]]|.+?(?=%))/).flatten.freeze

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

      def get_cached_open_tag_for_component(comp)
        COMPONENT_OPEN_TAG_CACHE[comp] ||= begin
          classes = get_cached_classes_for_component(comp)
          classes ? %(<span class="#{ERB::Util.html_escape(classes.join(" "))}">).freeze : "<span>"
        end
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
