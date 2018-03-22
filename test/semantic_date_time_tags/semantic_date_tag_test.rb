require 'test_helper'
require 'semantic_date_time_tags/view_helpers'

describe SemanticDateTimeTags::ViewHelpers do
  include SemanticDateTimeTags::ViewHelpers

  let(:date_object) { Date.parse("31/10/#{Date.today.year}") }
  let(:date_tomorrow_object) { Date.parse("31/10/#{Date.today.year}") + 1.day }
  let(:time_object) { Time.parse("31/10/#{Date.today.year}") }

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
      semantic_date_tag(Date.today, format: '%a, %b %-d, %Y').wont_include ' format='
    end
  end
end
