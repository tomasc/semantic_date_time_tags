# frozen_string_literal: true

require "test_helper"
require "semantic_date_time_tags/view_helpers"

describe SemanticDateTimeTags::ViewHelpers do
  include SemanticDateTimeTags::ViewHelpers

  let(:date_object) { Date.parse("31/10/#{Date.today.year}") }
  let(:date_tomorrow_object) { Date.parse("31/10/#{Date.today.year}") + 1.day }
  let(:time_object) { Time.parse("31/10/#{Date.today.year}") }

  describe "#semantic_date_range_tag" do
    let(:date_time_object_from) { DateTime.parse("31/10/#{Date.today.year}") }
    let(:date_time_object_to) { DateTime.parse("11/11/#{Date.today.year}") }

    let(:date_time_object_from_morning) { DateTime.parse("14/11/#{Date.today.year} 11:00") }
    let(:date_time_object_to_afternoon) { DateTime.parse("14/11/#{Date.today.year} 15:00") }

    it "should return nil when from date is nil" do
      _(semantic_date_range_tag(nil, date_time_object_to)).must_be_nil
    end

    it "should handle nil to date gracefully" do
      result = semantic_date_range_tag(date_time_object_from, nil)
      _(result).wont_be_nil
      _(result).must_match(/class="date_range/)
    end

    it "returns the from date wrapped correctly" do
      _(semantic_date_range_tag(date_object, date_tomorrow_object)).must_match(/<time.+?semantic.+?date.+?from.+?>.+?<time.+?semantic.+?date.+?to.+?>/)
    end

    it "adds same_year and current_year class to wrapping span" do
      _(semantic_date_range_tag(date_object, date_tomorrow_object)).must_match(/\A<span.+?date_range.+?same_year.+?current_year.+?>/)
    end

    it "adds same_day to wrapping span" do
      _(semantic_date_range_tag(date_time_object_from, date_time_object_from)).must_match(/\A<span.+?date_range.+?same_day.+?>/)
    end

    it "adds same_time to wrapping span" do
      _(semantic_date_range_tag(date_time_object_from, date_time_object_from)).must_match(/\A<span.+?date_range.+?same_day.+?same_time.+?>/)
    end

    it "adds am to wrapping span if both times in morning" do
      _(semantic_date_range_tag(date_time_object_from_morning - 1.hour, date_time_object_from_morning)).must_match(/\A<span.+?date_range.+?same_meridian.+?>/)
      _(semantic_date_range_tag(date_time_object_from_morning, date_time_object_to_afternoon)).wont_match(/\A<span.+?date_range.+?same_meridian.+?>/)
      _(semantic_date_range_tag(date_time_object_to_afternoon, date_time_object_to_afternoon + 1.hour)).must_match(/\A<span.+?date_range.+?same_meridian.+?>/)
    end

    it "accepts datetime objects" do
      _(semantic_date_range_tag(date_time_object_from, date_time_object_to)).must_match(/<time.+?from.+?<\/time>/)
      _(semantic_date_range_tag(date_time_object_from, date_time_object_to)).must_match(/<time.+?to.+?<\/time>/)
    end

    it "has an alias of semantic_date_tim_range_tag" do
      _(semantic_date_time_range_tag(date_object, date_tomorrow_object)).must_match(/<time.+?semantic.+?date.+?from.+?>/)
    end

    it "adds locale class" do
      _(semantic_date_time_range_tag(date_object, date_tomorrow_object)).must_match(/class=\".+\s#{I18n.locale}\s.+\"/i)
    end

    it "does not include separator attribute" do
      _(semantic_date_time_range_tag(date_object, date_tomorrow_object, separator: "–")).wont_match(/separator=/)
    end

    it "allows to pass :format" do
      _(semantic_date_time_range_tag(date_object, date_tomorrow_object, format: :test)).must_include "~"
      _(semantic_date_time_range_tag(date_object, date_tomorrow_object, format: :test)).must_include 'data-format="test"'
      _(semantic_time_tag(time_object, format: "%a, %b %-d, %Y, %-l:%M %P")).must_include 'data-format="%a, %b %-d, %Y, %-l:%M %P"'
      _(semantic_time_tag(time_object, format: "%a, %b %-d, %Y, %-l:%M %P")).wont_include " format="
    end

    it "allows to pass data attributes as a Hash" do
      _(semantic_date_time_range_tag(date_object, date_tomorrow_object, data: { name: "value" })).must_match(/\<span.+?data-name="value".+?\>/)
      _(semantic_date_time_range_tag(date_object, date_tomorrow_object, time_data: { time_name: "time value" })).must_match(/\<time.+?data-time-name="time value".+?\>/)
    end
  end
end
