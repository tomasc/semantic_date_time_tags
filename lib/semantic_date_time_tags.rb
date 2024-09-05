# frozen_string_literal: true

require_relative "semantic_date_time_tags/version"

require "action_view/helpers/tag_helper"
require "active_support/core_ext"
require "i18n"
require "zeitwerk"


I18n.load_path += Dir.glob(File.join(File.dirname(__FILE__), "config", "locales", "*.yml"))

module SemanticDateTimeTags
end

require "semantic_date_time_tags/railtie" if defined?(Rails)
require "semantic_date_time_tags/tag"

Zeitwerk::Loader.new.tap do |loader|
  loader.push_dir "#{__dir__}/semantic_date_time_tags/tag", namespace: SemanticDateTimeTags::Tag
  loader.setup
end

require "semantic_date_time_tags/format_parser"
require "semantic_date_time_tags/view_helpers"
