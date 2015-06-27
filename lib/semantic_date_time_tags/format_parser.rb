require 'action_view'

module SemanticDateTimeTags
  class FormatParser

    include ActionView::Helpers::TagHelper

    # ---------------------------------------------------------------------

    def initialize format, str
      @format = format
      @str = str
    end

    # ---------------------------------------------------------------------

    def to_html
      processed_str = @str
      formatting_components.flatten.inject('') do |res, comp|
        regexp = Regexp.new(get_regexp_for_component(comp))
        match = processed_str.match(regexp)[0]
        res += get_tag_for_match(match, comp)
        processed_str = processed_str[match.length..-1]
        res
      end.html_safe
    end

    private # =============================================================

    def formatting_components
      @format.scan /(%-?\w|.+?(?=%))/
    end

    def get_tag_for_match match, comp
      content_tag(:span, match, class: get_classes_for_component(comp))
    end

    def get_regexp_for_component comp
      case
      when comp =~ /%-?\w/ then "(\\w+)"
      else "(#{comp})"
      end
    end

    def get_classes_for_component comp
      case comp
      when /%-?[YCy]/ then ['year', comp[/\w/]]
      when /%-?[mBbh]/ then ['month', comp[/\w/]]
      when /%-?[dej]/ then ['day', comp[/\w/]]
      when /%-?[HKIl]/ then ['hours', comp[/\w/]]
      when /%-?[M]/ then ['minutes', comp[/\w/]]
      when /%-?[p]/ then ['ampm', comp[/\w/]]
      when /\W+/ then ['sep']
      end
    end

  end
end
