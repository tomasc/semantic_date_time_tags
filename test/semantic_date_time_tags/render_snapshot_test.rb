# frozen_string_literal: true

require "test_helper"
require "yaml"
require "active_support/testing/time_helpers"

# Pins the exact HTML every tag renders, so a change to how the markup is built
# (rather than what it says) is provably a no-op. Regenerate deliberately with
# `UPDATE_SNAPSHOTS=1 bundle exec rake test` and review the fixture diff.
describe "render snapshot" do
  include ActiveSupport::Testing::TimeHelpers
  include SemanticDateTimeTags::ViewHelpers

  SNAPSHOT_PATH = File.expand_path("../fixtures/render_snapshot.yml", __dir__)

  NOW = Time.utc(2026, 10, 8, 9, 30)

  date = Date.new(2026, 10, 8)
  other_date = Date.new(2025, 2, 3)
  noon = DateTime.new(2026, 10, 8, 12, 0)
  midnight = DateTime.new(2026, 10, 9, 0, 0)
  afternoon = DateTime.new(2026, 10, 8, 15, 45, 30)
  morning = DateTime.new(2026, 10, 8, 9, 5)
  time = Time.utc(2026, 10, 8, 18, 0)

  CASES = {
    "date / full" => -> { semantic_date_tag(date) },
    "date / test" => -> { semantic_date_tag(other_date, format: :test) },
    "date / string format with words" => -> { semantic_date_tag(date, format: "%A, %B %-d, %Y") },
    "date / unsafe literal" => -> { semantic_date_tag(date, format: "%Y & <%m>") },
    "date / word-only literal" => -> { semantic_date_tag(date, format: "%YT%m") },
    "date / options" => -> { semantic_date_tag(date, class: "extra", data: { foo: "bar" }, aria: { describedby: "x" }, tag_name: :span) },
    "date / no aria label" => -> { semantic_date_tag(date, aria_label: false) },
    "date / datetime object" => -> { semantic_date_tag(noon) },

    "date_time / noon" => -> { semantic_date_time_tag(noon) },
    "date_time / midnight" => -> { semantic_date_time_tag(midnight, format: :test) },
    "date_time / seconds and ampm" => -> { semantic_date_time_tag(afternoon, format: "%-d %b %Y, %-l:%M:%S %p") },
    "date_time / padded hour" => -> { semantic_date_time_tag(morning, format: "%e %B at %l:%M %P") },
    "date_time / span tag" => -> { semantic_date_time_tag(afternoon, tag_name: :span, class: %w[a b]) },
    "date_time / missing format" => -> { semantic_date_time_tag(afternoon, format: :missing) },

    "time / full" => -> { semantic_time_tag(time) },
    "time / test" => -> { semantic_time_tag(time, format: :test, aria: { label: "Custom" }) },

    "range / dates" => -> { semantic_date_range_tag(date, date + 3) },
    "range / dates spanning years" => -> { semantic_date_range_tag(other_date, date) },
    "range / open ended" => -> { semantic_date_range_tag(date, nil) },
    "range / date times same day" => -> { semantic_date_range_tag(morning, afternoon) },
    "range / date times across days" => -> { semantic_date_range_tag(noon, midnight, separator: " to ", format: :test) },
    "range / data and time_data" => -> { semantic_date_range_tag(date, date + 1, data: { a: 1 }, time_data: { b: 2 }) },

    "parser / trailing remainder" => -> { SemanticDateTimeTags::FormatParser.new("%Y", "2026 and more").to_html },
    "parser / unmatched literal" => -> { SemanticDateTimeTags::FormatParser.new("%Y-%m", "2026/10").to_html },
    "parser / unsafe remainder" => -> { SemanticDateTimeTags::FormatParser.new("%Y", "2026 <b>&</b>").to_html },
    "parser / html_safe remainder" => -> { SemanticDateTimeTags::FormatParser.new("%Y", "2026 <b>&</b>".html_safe).to_html },
    "parser / classless literal" => -> { SemanticDateTimeTags::FormatParser.new("x%Y", "x2026").to_html },
    "parser / blank" => -> { SemanticDateTimeTags::FormatParser.new("%Y", "").to_html }
  }.freeze

  def rendered
    travel_to(NOW) { CASES.transform_values { |c| instance_exec(&c).to_s } }
  end

  if ENV["UPDATE_SNAPSHOTS"]
    it "writes the snapshot" do
      File.write(SNAPSHOT_PATH, rendered.to_yaml(line_width: -1))
    end
  else
    snapshot = YAML.load_file(SNAPSHOT_PATH)

    it "covers exactly the snapshotted cases" do
      _(CASES.keys).must_equal snapshot.keys
    end

    CASES.each_key do |name|
      it "renders #{name} unchanged" do
        _(rendered.fetch(name)).must_equal snapshot.fetch(name)
      end
    end
  end
end
