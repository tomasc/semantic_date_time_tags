# frozen_string_literal: true

require "test_helper"
require "semantic_date_time_tags/view_helpers"

describe SemanticDateTimeTags::ViewHelpers do
  include SemanticDateTimeTags::ViewHelpers

  describe "ARIA attribute support" do
    describe "semantic_date_tag" do
      let(:date) { Date.new(2024, 12, 25) }

      it "adds automatic aria-label" do
        output = semantic_date_tag(date)
        _(output).must_include 'aria-label="Date: Wednesday, December 25, 2024"'
      end

      it "allows custom aria-label" do
        output = semantic_date_tag(date, aria: { label: "Christmas Day" })
        _(output).must_include 'aria-label="Christmas Day"'
      end

      it "supports multiple ARIA attributes" do
        output = semantic_date_tag(date, aria: { label: "Holiday", describedby: "holiday-info" })
        _(output).must_include 'aria-label="Holiday"'
        _(output).must_include 'aria-describedby="holiday-info"'
      end

      it "can disable automatic aria-label" do
        output = semantic_date_tag(date, aria_label: false)
        _(output).wont_include 'aria-label'
      end
    end

    describe "semantic_time_tag" do
      let(:time_obj) { Time.new(2024, 12, 25, 14, 30, 0) }

      it "adds automatic aria-label" do
        output = semantic_time_tag(time_obj)
        _(output).must_include 'aria-label="Time: 2:30 PM"'
      end

      it "allows custom aria-label" do
        output = semantic_time_tag(time_obj, aria: { label: "Meeting time" })
        _(output).must_include 'aria-label="Meeting time"'
      end
    end

    describe "semantic_date_time_tag" do
      let(:datetime) { DateTime.new(2024, 12, 25, 14, 30, 0) }

      it "adds automatic aria-label" do
        output = semantic_date_time_tag(datetime)
        _(output).must_include 'aria-label="Date and time: Wednesday, December 25, 2024 at 2:30 PM"'
      end

      it "allows custom aria-label" do
        output = semantic_date_time_tag(datetime, aria: { label: "Event start time" })
        _(output).must_include 'aria-label="Event start time"'
      end
    end

    describe "semantic_date_range_tag" do
      let(:date_from) { Date.new(2024, 12, 20) }
      let(:date_to) { Date.new(2024, 12, 25) }

      it "adds automatic aria-label" do
        output = semantic_date_range_tag(date_from, date_to)
        _(output).must_include 'aria-label="Date range: December 20, 2024 to December 25, 2024"'
      end

      it "handles open-ended ranges" do
        output = semantic_date_range_tag(date_from, nil)
        _(output).must_include 'aria-label="Date range starting: December 20, 2024"'
        # Verify CSS classes for open-ended ranges
        _(output).must_include 'class="date_range same_year same_month same_day same_time same_meridian"'
      end

      it "allows custom aria-label" do
        output = semantic_date_range_tag(date_from, date_to, aria: { label: "Holiday week" })
        _(output).must_include 'aria-label="Holiday week"'
      end

      it "supports multiple ARIA attributes" do
        output = semantic_date_range_tag(date_from, date_to, aria: { label: "Vacation", role: "region" })
        _(output).must_include 'aria-label="Vacation"'
        _(output).must_include 'aria-role="region"'
      end
    end
  end
end