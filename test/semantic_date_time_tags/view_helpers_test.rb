require 'test_helper'
require 'semantic_date_time_tags/view_helpers'

describe SemanticDateTimeTags::ViewHelpers do
  include SemanticDateTimeTags::ViewHelpers

  let(:date_object) { Date.parse("31/10/#{Date.today.year}") }
  let(:date_tomorrow_object) { Date.parse("31/10/#{Date.today.year}") + 1.day }
  let(:time_object) { Time.parse("31/10/#{Date.today.year}") }

  # ---------------------------------------------------------------------

  describe '#semantic_time_tag' do
    let(:time_object_hours) { time_object.strftime('%H') }
    let(:time_object_midnight) { Time.new(Date.today.year, 11, 3, 24, 00) }
    let(:time_object_minutes) { time_object.strftime('%M') }
    let(:time_object_noon) { Time.new(Date.today.year, 11, 3, 12, 00) }
    let(:time_object_whole_hour) { Time.new(2014, 8, 21, 15) }
    let(:time_object_whole_minute) { Time.new(2014, 8, 21, 15, 30) }
    let(:time_object_before_noon) { Time.new(2014, 8, 21, 11, 00) }
    let(:time_object_after_noon) { Time.new(2014, 8, 21, 12, 01) }

    it 'does not work with a date object' do
      proc { semantic_time_tag(date_object) }.must_raise RuntimeError
    end

    it 'returns hours wrapped in a span tag' do
      semantic_time_tag(time_object).must_match(Regexp.new("<span.+?hours.+?H.+?>#{time_object_hours}</span>"))
    end

    it 'returns minutes wrapped in a span tag' do
      semantic_time_tag(time_object).must_match(Regexp.new("<span.+?minutes.+?M.+?>#{time_object_minutes}</span>"))
    end

    it 'wraps the whole thing in a time tag by default' do
      semantic_time_tag(time_object).must_match(/\A<time.+?<\/time>\z/)
    end

    it 'wraps the whole thing in a span tag if passed as argument' do
      semantic_time_tag(time_object, tag_name: :span).must_match(/\A<span.+?<\/span>\z/)
    end

    it 'adds whole_hour class if time is whole hour' do
      semantic_time_tag(time_object_whole_hour).must_match(/\A<time.+?whole_hour.+?<\/time>\z/)
    end

    it 'adds whole_minute class if time is whole minute' do
      semantic_time_tag(time_object_whole_minute).must_match(/\A<time.+?whole_minute.+?<\/time>\z/)
    end

    it 'adds noon class if time is noon' do
      semantic_time_tag(time_object_noon).must_match(/\A<time.+?noon.+?<\/time>\z/)
    end

    it 'adds midnight class if time is midnight' do
      semantic_time_tag(time_object_midnight).must_match(/\A<time.+?midnight.+?<\/time>\z/)
    end

    it 'adds am class if time is before noon' do
      semantic_time_tag(time_object_before_noon).must_match(/\A<time.+?am.+?<\/time>\z/)
    end

    it 'adds pm class if time is after noon' do
      semantic_time_tag(time_object_after_noon).must_match(/\A<time.+?pm.+?<\/time>\z/)
    end

    it 'adds noon as data-in-words if time is noon' do
      semantic_time_tag(time_object_noon).must_match(/\A<time.+?data-in-words=\"noon\".+?<\/time>\z/)
    end

    it 'adds midnight as data-in-words if time is midnight' do
      semantic_time_tag(time_object_midnight).must_match(/\A<time.+?data-in-words=\"midnight\".+?<\/time>\z/)
    end

    it 'adds locale class' do
      semantic_time_tag(time_object).must_match(/class=\".+\s#{I18n.locale}\s.+\"/i)
    end

    it 'allows to pass :format' do
      semantic_time_tag(time_object, format: :test).must_include '~'
      semantic_time_tag(time_object, format: :test).must_include 'data-format="test"'
      semantic_time_tag(time_object, format: '%-l:%M %P').must_include 'data-format="%-l:%M %P"'
    end
  end

  # ---------------------------------------------------------------------

  describe '#semantic_date_tag' do
    let(:date_object_day) { date_object.strftime('%-d') }
    let(:date_object_month) { date_object.strftime('%-m') }
    let(:date_object_year) { date_object.year }

    it 'should only work with a date or datetime object' do
      proc { semantic_date_tag(time_object) }.must_raise RuntimeError
    end

    it 'wraps everything in a time tag by default' do
      semantic_date_tag(date_object).must_match(/\A<time.+?<\/time>\z/)
    end

    it 'wraps everything in a span tag if passed as argument' do
      semantic_date_tag(date_object, tag_name: :span).must_match(/\A<span.+?<\/span>\z/)
    end

    it 'returns year, month and day wrapped in a span tags' do
      semantic_date_tag(date_object).must_match(Regexp.new("<span.+?year.+?>#{date_object_year}</span>"))
      semantic_date_tag(date_object).must_match(Regexp.new("<span.+?month.+?>#{date_object_month}</span>"))
      semantic_date_tag(date_object).must_match(Regexp.new("<span.+?day.+?>#{date_object_day}</span>"))
    end

    it 'adds current_date class if date is today' do
      semantic_date_tag(Date.today).must_include 'current_date'
      semantic_date_tag(Date.today - 1.day).wont_include 'current_date'
    end

    it 'adds current class to year span if date is this year' do
      semantic_date_tag(Date.today).must_include 'current_year'
      semantic_date_tag(Date.today - 1.year).wont_include 'current_year'
    end

    it 'adds locale class' do
      semantic_date_tag(Date.today).must_match(/class=\".+\s#{I18n.locale}\s.+\"/i)
    end

    it 'allows to pass :format' do
      semantic_date_tag(Date.today, format: :test).must_include '~'
      semantic_date_tag(Date.today, format: :test).must_include 'data-format="test"'
      semantic_date_tag(Date.today, format: '%a, %b %-d, %Y').must_include 'data-format="%a, %b %-d, %Y"'
    end
  end

  # ---------------------------------------------------------------------

  describe '#semantic_date_time_tag' do
    let(:date_time_object) { DateTime.parse("31/10/#{Date.today.year}") }
    let(:date_time_object_noon) { DateTime.parse("31/10/#{Date.today.year}").noon }
    let(:date_time_object_midnight) { DateTime.parse("31/10/#{Date.today.year}").midnight }

    it 'only works with a time or date_time object' do
      proc { semantic_date_time_tag(time_object) }.must_raise RuntimeError
    end

    it 'wraps the whole thing in a time tag' do
      semantic_date_time_tag(date_time_object).must_match(/\A<time.+?<\/time>\z/)
    end

    it 'adds noon as data-in-words if time is noon' do
      semantic_date_time_tag(date_time_object_noon).must_match(/\A<time.+?data-in-words=\"noon\".+?<\/time>\z/)
    end

    it 'adds midnight as data-in-words if time is midnight' do
      semantic_date_time_tag(date_time_object_midnight).must_match(/\A<time.+?data-in-words=\"midnight\".+?<\/time>\z/)
    end

    it 'adds locale class' do
      semantic_date_time_tag(date_time_object).must_match(/class=\".+\s#{I18n.locale}\s.+\"/i)
    end

    it 'allows to pass :format' do
      semantic_date_time_tag(date_time_object, format: :test).must_include '~'
      semantic_date_time_tag(date_time_object, format: :test).must_include 'data-format="test"'
      semantic_date_time_tag(date_time_object, format: '%a, %b %-d, %Y, %-l:%M %P').must_include 'data-format="%a, %b %-d, %Y, %-l:%M %P"'
    end
  end

  # ---------------------------------------------------------------------

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
    end
  end
end
