require 'test_helper'
require 'semantic_date_time_tags/view_helpers'

describe SemanticDateTimeTags::ViewHelpers do
  include SemanticDateTimeTags::ViewHelpers

  let(:date_object) { Date.parse("31/10/#{Date.today.year}") }
  let(:date_tomorrow_object) { Date.parse("31/10/#{Date.today.year}") + 1.day }
  let(:time_object) { Time.parse("31/10/#{Date.today.year}") }

  describe '#semantic_date_range_tag' do
    let(:date_time_object_from) { DateTime.parse("31/10/#{Date.today.year}") }
    let(:date_time_object_to) { DateTime.parse("11/11/#{Date.today.year}") }

    let(:date_time_object_from_morning) { DateTime.parse("14/11/#{Date.today.year} 11:00") }
    let(:date_time_object_to_afternoon) { DateTime.parse("14/11/#{Date.today.year} 15:00") }

    it 'returns the from date wrapped correctly' do
      semantic_date_range_tag(date_object, date_tomorrow_object).must_match(/<time.+?semantic.+?date.+?from.+?>.+?<time.+?semantic.+?date.+?to.+?>/)
    end

    it 'adds same_year and current_year class to wrapping span' do
      semantic_date_range_tag(date_object, date_tomorrow_object).must_match(/\A<span.+?date_range.+?current_year.+?>/)
    end

    it 'adds same_day to wrapping span' do
      semantic_date_range_tag(date_time_object_from, date_time_object_from).must_match(/\A<span.+?date_range.+?same_day.+?>/)
    end

    it 'adds same_time to wrapping span' do
      semantic_date_range_tag(date_time_object_from, date_time_object_from).must_match(/\A<span.+?date_range.+?same_day.+?same_time.+?>/)
    end

    it 'adds am to wrapping span if both times in morning' do
      semantic_date_range_tag(date_time_object_from_morning - 1.hour, date_time_object_from_morning).must_match(/\A<span.+?date_range.+?same_meridian.+?>/)
      semantic_date_range_tag(date_time_object_from_morning, date_time_object_to_afternoon).wont_match(/\A<span.+?date_range.+?same_meridian.+?>/)
      semantic_date_range_tag(date_time_object_to_afternoon, date_time_object_to_afternoon + 1.hour).must_match(/\A<span.+?date_range.+?same_meridian.+?>/)
    end

    it 'accepts datetime objects' do
      semantic_date_range_tag(date_time_object_from, date_time_object_to).must_match(/<time.+?from.+?<\/time>/)
      semantic_date_range_tag(date_time_object_from, date_time_object_to).must_match(/<time.+?to.+?<\/time>/)
    end

    it 'has an alias of semantic_date_tim_range_tag' do
      semantic_date_time_range_tag(date_object, date_tomorrow_object).must_match(/<time.+?semantic.+?date.+?from.+?>/)
    end

    it 'adds locale class' do
      semantic_date_time_range_tag(date_object, date_tomorrow_object).must_match(/class=\".+\s#{I18n.locale}\s.+\"/i)
    end

    it 'does not include separator attribute' do
      semantic_date_time_range_tag(date_object, date_tomorrow_object, separator: '–').wont_match(/separator=/)
    end

    it 'allows to pass :format' do
      semantic_date_time_range_tag(date_object, date_tomorrow_object, format: :test).must_include '~'
      semantic_date_time_range_tag(date_object, date_tomorrow_object, format: :test).must_include 'data-format="test"'
      semantic_time_tag(time_object, format: '%a, %b %-d, %Y, %-l:%M %P').must_include 'data-format="%a, %b %-d, %Y, %-l:%M %P"'
      semantic_time_tag(time_object, format: '%a, %b %-d, %Y, %-l:%M %P').wont_include ' format='
    end
  end
end
