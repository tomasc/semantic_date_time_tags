# frozen_string_literal: true

require "test_helper"
require "active_support/testing/time_helpers"

describe "current_date and current_year" do
  include ActiveSupport::Testing::TimeHelpers
  include SemanticDateTimeTags::ViewHelpers

  # 05:00 UTC on New Year's Day is still New Year's Eve in Honolulu, so the
  # system date and the application time zone's date are a year apart.
  let(:new_years_day_utc) { Time.utc(2027, 1, 1, 5, 0) }
  let(:new_years_eve) { Date.new(2026, 12, 31) }

  def classes_of(html, tag)
    html[/<#{tag}[^>]*class="([^"]*)"/, 1].split
  end

  def in_honolulu(&block)
    travel_to(new_years_day_utc) { Time.use_zone("Pacific/Honolulu", &block) }
  end

  it "marks the application time zone's today as in the current year" do
    in_honolulu do
      _(classes_of(semantic_date_tag(new_years_eve), "time")).must_include "current_date"
      _(classes_of(semantic_date_tag(new_years_eve), "time")).must_include "current_year"
    end
  end

  it "does not mark the system date's year in the application time zone" do
    in_honolulu do
      _(classes_of(semantic_date_tag(Date.new(2027, 1, 1)), "time")).wont_include "current_year"
    end
  end

  it "marks a range ending today in the application time zone as in the current year" do
    in_honolulu do
      html = semantic_date_range_tag(new_years_eve - 1, new_years_eve)

      _(classes_of(html, "span")).must_include "current_year"
      _(classes_of(html, "time")).must_include "current_year"
    end
  end
end
