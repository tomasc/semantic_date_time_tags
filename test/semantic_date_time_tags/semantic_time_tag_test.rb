# frozen_string_literal: true

require "test_helper"
require "semantic_date_time_tags/view_helpers"

describe SemanticDateTimeTags::ViewHelpers do
  include SemanticDateTimeTags::ViewHelpers

  let(:date_object) { Date.parse("31/10/#{Date.today.year}") }
  let(:date_tomorrow_object) { Date.parse("31/10/#{Date.today.year}") + 1.day }
  let(:time_object) { Time.parse("31/10/#{Date.today.year}") }

  describe "#semantic_time_tag" do
    let(:time_object_hours) { time_object.strftime("%H") }
    let(:time_object_midnight) { Time.new(Date.today.year, 11, 3, 24, 00) }
    let(:time_object_minutes) { time_object.strftime("%M") }
    let(:time_object_noon) { Time.new(Date.today.year, 11, 3, 12, 00) }
    let(:time_object_whole_hour) { Time.new(2014, 8, 21, 15) }
    let(:time_object_whole_minute) { Time.new(2014, 8, 21, 15, 30) }
    let(:time_object_before_noon) { Time.new(2014, 8, 21, 11, 00) }
    let(:time_object_after_noon) { Time.new(2014, 8, 21, 12, 01) }

    it "does not work with a date object" do
      _(proc { semantic_time_tag(date_object) }).must_raise RuntimeError
    end

    it "returns hours wrapped in a span tag" do
      _(semantic_time_tag(time_object)).must_match(Regexp.new("<span.+?hours.+?H.+?>#{time_object_hours}</span>"))
    end

    it "returns minutes wrapped in a span tag" do
      _(semantic_time_tag(time_object)).must_match(Regexp.new("<span.+?minutes.+?M.+?>#{time_object_minutes}</span>"))
    end

    it "wraps the whole thing in a time tag by default" do
      _(semantic_time_tag(time_object)).must_match(/\A<time.+?<\/time>\z/)
    end

    it "wraps the whole thing in a span tag if passed as argument" do
      _(semantic_time_tag(time_object, tag_name: :span)).must_match(/\A<span.+?<\/span>\z/)
    end

    it "adds whole_hour class if time is whole hour" do
      _(semantic_time_tag(time_object_whole_hour)).must_match(/\A<time.+?whole_hour.+?<\/time>\z/)
    end

    it "adds whole_minute class if time is whole minute" do
      _(semantic_time_tag(time_object_whole_minute)).must_match(/\A<time.+?whole_minute.+?<\/time>\z/)
    end

    it "adds noon class if time is noon" do
      _(semantic_time_tag(time_object_noon)).must_match(/\A<time.+?noon.+?<\/time>\z/)
    end

    it "adds midnight class if time is midnight" do
      _(semantic_time_tag(time_object_midnight)).must_match(/\A<time.+?midnight.+?<\/time>\z/)
    end

    it "adds am class if time is before noon" do
      _(semantic_time_tag(time_object_before_noon)).must_match(/\A<time.+?am.+?<\/time>\z/)
    end

    it "adds pm class if time is after noon" do
      _(semantic_time_tag(time_object_after_noon)).must_match(/\A<time.+?pm.+?<\/time>\z/)
    end

    it "adds noon as data-in-words if time is noon" do
      _(semantic_time_tag(time_object_noon)).must_match(/\A<time.+?data-in-words=\"noon\".+?<\/time>\z/)
    end

    it "adds midnight as data-in-words if time is midnight" do
      _(semantic_time_tag(time_object_midnight)).must_match(/\A<time.+?data-in-words=\"midnight\".+?<\/time>\z/)
    end

    it "adds locale class" do
      _(semantic_time_tag(time_object)).must_match(/class=\".+\s#{I18n.locale}\s.+\"/i)
    end

    it "allows to pass :format" do
      _(semantic_time_tag(time_object, format: :test)).must_include "~"
      _(semantic_time_tag(time_object, format: :test)).must_include 'data-format="test"'
      _(semantic_time_tag(time_object, format: "%-l:%M %P")).must_include 'data-format="%-l:%M %P"'
      _(semantic_time_tag(time_object, format: "%-l:%M %P")).wont_include " format="
    end
  end
end
