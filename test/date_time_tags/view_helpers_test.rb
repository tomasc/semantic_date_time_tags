require 'date_time_tags/view_helpers'
require 'test_helper'

module DateTimeTags
  describe ViewHelpers do
    include ViewHelpers
    include ActionView::Helpers
    include ActionView::Helpers::TagHelper

    # =====================================================================

    let(:time_object) { Time.now }
    let(:date_object) { Date.today }
    let(:date_time_object) { DateTime.now }

    # ---------------------------------------------------------------------

    describe '#markup_localized_date_or_time_string' do
      let(:template) { '%-d.%-m.%Y' }
      let(:string) { '25.8.2014' }
      let(:result) { markup_localized_date_or_time_string(string, template) }

      # it 'should wrap each value group with span' do
      #   result.must_include "<span class=\"day\">25</span>"
      #   result.must_include "<span class=\"month\">8</span>"
      #   result.must_include "<span class=\"year\">2014</span>"
      # end
    end

    # ---------------------------------------------------------------------

    # describe '#time_tags' do
    #   let(:time_object_hours) { time_object.strftime('%H') }
    #   let(:time_object_minutes) { time_object.strftime('%M') }
    #   let(:time_object_whole_hour) { Time.new(2014, 8, 21, 15) }
    #   let(:time_object_whole_minute) { Time.new(2014, 8, 21, 15, 30) }

    #   it 'does not work with a date object' do
    #     time_tags(date_object).must_be_nil
    #   end

    #   it 'returns hours wrapped in a span tag' do
    #     time_tags(time_object).must_match Regexp.new(".*?<span class=\"hours\">#{time_object_hours}</span>.*?")
    #   end

    #   it 'returns minutes wrapped in a span tag' do
    #     time_tags(time_object).must_match Regexp.new(".*?<span class=\"minutes\">#{time_object_minutes}</span>.*?")
    #   end

    #   it 'wraps the whole thing in a time tag by default' do
    #     time_tags(time_object).must_match Regexp.new("\\A<time.*?>.*?</time>\\z")
    #   end

    #   it 'wraps the whole thing in a span tag if passed as argument' do
    #     time_tags(time_object, :span).must_match Regexp.new("\\A<span.*?>.*?</span>\\z")
    #   end

    #   it 'adds whole_hour class if time is whole hour' do
    #     time_tags(time_object_whole_hour).must_match Regexp.new("\\A<time.*? class=\".*?whole_hour.*?\">.*?</time>\\z")
    #   end

    #   it 'adds whole_minute class if time is whole minute' do
    #     time_tags(time_object_whole_minute).must_match Regexp.new("\\A<time.*? class=\".*?whole_minute.*?\">.*?</time>\\z")
    #   end
    # end

    # ---------------------------------------------------------------------

    describe '#date_tag' do
      let(:date_object_day) { date_object.strftime('%-d') }
      let(:date_object_month) { date_object.strftime('%-m') }
      let(:date_object_year) { date_object.year }
      let(:date_object_yesterday) { Date.yesterday }
      let(:date_object_last_year) { Date.civil( date_object.year-1, date_object.month, date_object.day ) }

      it 'should only work with a date or datetime object' do
        # date_tag(time_object).must_be_nil
        # date_tag("some string").must_be_nil
        # date_tag(123).must_be_nil
        # date_tag(true).must_be_nil
        # date_tag(date_object).wont_be_nil
        date_tag(date_time_object).wont_be_nil
      end

      # it 'should wrap the whole thing in a time tag by default' do
      #   date_tag(date_object).must_match Regexp.new("\\A<time.*?>.*?</time>\\z")
      # end

      # it 'wraps the whole thing in a span tag if passed as argument' do
      #   date_tag(date_object, nil, :span).must_match Regexp.new("\\A<span.*?>.*?</span>\\z")
      # end

      # it 'returns year wrapped in a span tag' do
      #   date_tag(date_object).must_match Regexp.new(".*?<span class=\"year .*?\">#{date_object_year}</span>.*?")
      # end

      # it 'returns month wrapped in a span tag' do
      #   date_tag(date_object).must_match Regexp.new(".*?<span class=\"month\" title=\".*?\">#{date_object_month}</span>.*?")
      # end

      # it 'returns day wrapped in a span tag' do
      #   date_tag(date_object).must_match Regexp.new(".*?<span class=\"day\" title=\".*?\">#{date_object_day}</span>.*?")
      # end

      # it 'adds current class if date is today' do
      #   date_tag(date_object).must_match Regexp.new("\\A<time.*?class=\".*?current\".*?>.*?</time>\\z")
      # end

      # it 'does not add current class if date is not today' do
      #   date_tag(date_object_yesterday).wont_match Regexp.new("\\A<time.*?class=\"date current\".*?>.*?</time>\\z")
      # end

      # it 'adds current class to year span if date is this year' do
      #   date_tag(date_object).must_match Regexp.new(".*?<span class=\"year current\">#{date_object_year}</span>.*?")
      # end

      # it 'does not add current class to year span if date is not this year' do
      #   date_tag(date_object_last_year).wont_match Regexp.new(".*?<span class=\"year current\">#{date_object_year}</span>.*?")
      # end

    end

    # ---------------------------------------------------------------------

    # describe '#date_time_tag' do
    #   it 'only works with a time or date_time object' do
    #     date_time_tag(date_object).must_be_nil
    #     date_time_tag("some string").must_be_nil
    #     date_time_tag(123).must_be_nil
    #     date_time_tag(true).must_be_nil
    #     date_time_tag(time_object).wont_be_nil
    #     date_time_tag(date_time_object).wont_be_nil
    #   end

    #   it 'wraps the whole thing in a time tag' do
    #     date_time_tag(date_time_object).must_match Regexp.new("\\A<time.*?>.*?</time>\\z")
    #   end
    # end

    # ---------------------------------------------------------------------

  end
end