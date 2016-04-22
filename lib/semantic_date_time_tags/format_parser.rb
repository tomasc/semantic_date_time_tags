# encoding: utf-8
require 'action_view'

module SemanticDateTimeTags
  class FormatParser < Struct.new(:format, :str)
    include ActionView::Helpers::TagHelper

    def to_html
      processed_str = str
      formatting_components.flatten.inject('') do |res, comp|
        regexp = Regexp.new(get_regexp_for_component(comp))
        if match = processed_str.match(regexp)
          res += get_tag_for_match(match[0], comp)
          processed_str = processed_str[match[0].length..-1]
        end
        res
      end.html_safe
    end

    private # =============================================================

    def formatting_components
      format.scan(/(%-?[[:word:]]|.+?(?=%))/)
    end

    def get_tag_for_match(match, comp)
      content_tag :span, match, class: get_classes_for_component(comp)
    end

    def get_regexp_for_component(comp)
      case comp
      when /%-?[[:word:]]/ then '([[:word:]]+)'
      else "(#{comp})"
      end
    end

    def get_classes_for_component(comp)
      case comp
      when /%-?[YCy]/ then ['year', comp[/[[:word:]]/]]
      when /%-?[mBbh]/ then ['month', comp[/[[:word:]]/]]
      when /%-?[aAdej]/ then ['day', comp[/[[:word:]]/]]
      when /%-?[HKIl]/ then ['hours', comp[/[[:word:]]/]]
      when /%-?[M]/ then ['minutes', comp[/[[:word:]]/]]
      when /%-?[pP]/ then ['ampm', comp[/[[:word:]]/]]
      when /\W+/ then ['sep']
      end
    end
  end
end
