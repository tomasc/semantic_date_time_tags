require 'test_helper'
require 'date_time_tags/view_helpers'

module DateTimeTags
  describe ViewHelpers do

    include ViewHelpers

    # include ActionView::Helpers
    # include ActionView::Helpers::DateHelper
    # include ActionView::Helpers::TagHelper

    # =====================================================================

    let(:time_object) { Time.now }
    let(:date_object) { Date.today }
    let(:date_tomorrow_object) { Date.tomorrow }
    let(:date_time_object) { DateTime.now }

    # ---------------------------------------------------------------------

    describe '#time_tags' do
      let(:time_object_hours) { time_object.strftime('%H') }
      let(:time_object_minutes) { time_object.strftime('%M') }
      let(:time_object_whole_hour) { Time.new(2014, 8, 21, 15) }
      let(:time_object_whole_minute) { Time.new(2014, 8, 21, 15, 30) }

      it 'does not work with a date object' do
        proc { time_tags(date_object) }.must_raise RuntimeError
      end

      it 'returns hours wrapped in a span tag' do
        time_tags(time_object).must_match Regexp.new(".*?<span class=\"hours H\">#{time_object_hours}</span>.*?")
      end

      it 'returns minutes wrapped in a span tag' do
        time_tags(time_object).must_match Regexp.new(".*?<span class=\"minutes M\">#{time_object_minutes}</span>.*?")
      end

      it 'wraps the whole thing in a time tag by default' do
        time_tags(time_object).must_match Regexp.new("\\A<time.*?>.*?</time>\\z")
      end

      it 'wraps the whole thing in a span tag if passed as argument' do
        time_tags(time_object, :span).must_match Regexp.new("\\A<span.*?>.*?</span>\\z")
      end

      it 'adds whole_hour class if time is whole hour' do
        time_tags(time_object_whole_hour).must_match Regexp.new("\\A<time.*? class=\".*?whole_hour.*?\">.*?</time>\\z")
      end

      it 'adds whole_minute class if time is whole minute' do
        time_tags(time_object_whole_minute).must_match Regexp.new("\\A<time.*? class=\".*?whole_minute.*?\">.*?</time>\\z")
      end
    end

    # ---------------------------------------------------------------------

    describe '#date_tag' do
      let(:date_object_day) { date_object.strftime('%-d') }
      let(:date_object_month) { date_object.strftime('%-m') }
      let(:date_object_year) { date_object.year }
      let(:date_object_yesterday) { Date.yesterday }
      let(:date_object_last_year) { Date.civil( date_object.year-1, date_object.month, date_object.day ) }

      it 'should only work with a date or datetime object' do
        proc { date_time_tag(time_object) }.must_raise RuntimeError
      end

      it 'wraps everything in a time tag by default' do
        date_tag(date_object).must_match Regexp.new("\\A<time.*?>.*?</time>\\z")
      end

      it 'wraps everything in a span tag if passed as argument' do
        date_tag(date_object, :span).must_match Regexp.new("\\A<span.*?>.*?</span>\\z")
      end

      it 'returns year, month and day wrapped in a span tags' do
        date_tag(date_object).must_match Regexp.new(".*?<span class=\"year .*?\">#{date_object_year}</span>.*?")
        date_tag(date_object).must_match Regexp.new(".*?<span class=\"month .*?\">#{date_object_month}</span>.*?")
        date_tag(date_object).must_match Regexp.new(".*?<span class=\"day .*?\">#{date_object_day}</span>.*?")
      end

      it 'adds current_date class if date is today' do
        date_tag(date_object).must_include "current_date"
        date_tag(date_object_yesterday).wont_include "current_date"
      end

      it 'adds current class to year span if date is this year' do
        date_tag(date_object).must_include "current_year"
        date_tag(date_object_last_year).wont_include "current_year"
      end

    end

    # ---------------------------------------------------------------------

    describe '#date_time_tag' do
      it 'only works with a time or date_time object' do
        proc { date_time_tag(time_object) }.must_raise RuntimeError
      end

      it 'wraps the whole thing in a time tag' do
        date_time_tag(date_time_object).must_match Regexp.new("\\A<time.*?>.*?</time>\\z")
      end
    end

    # ---------------------------------------------------------------------

    describe '#date_range_tag' do
      it 'returns the from date wrapped correctly' do
        date_range_tag(date_object, date_tomorrow_object).must_match Regexp.new("<time class=\"date current_date current_year from\".*?>.*?</time>")
      end
    end

    # ---------------------------------------------------------------------

  end
end