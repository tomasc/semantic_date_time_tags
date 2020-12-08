require 'test_helper'
require 'semantic_date_time_tags/view_helpers'

describe SemanticDateTimeTags::ViewHelpers do
  include SemanticDateTimeTags::ViewHelpers

  let(:date_object) { Date.parse("31/10/#{Date.today.year}") }
  let(:date_tomorrow_object) { Date.parse("31/10/#{Date.today.year}") + 1.day }
  let(:time_object) { Time.parse("31/10/#{Date.today.year}") }

  describe '#semantic_date_time_tag' do
    let(:date_time_object) { DateTime.parse("31/10/#{Date.today.year}") }
    let(:date_time_object_noon) { DateTime.parse("31/10/#{Date.today.year}").noon }
    let(:date_time_object_midnight) { DateTime.parse("31/10/#{Date.today.year}").midnight }

    it 'only works with a time or date_time object' do
      _(proc { semantic_date_time_tag(time_object) }).must_raise RuntimeError
    end

    it 'wraps the whole thing in a time tag' do
      _(semantic_date_time_tag(date_time_object)).must_match(/\A<time.+?<\/time>\z/)
    end

    it 'adds noon as data-in-words if time is noon' do
      _(semantic_date_time_tag(date_time_object_noon)).must_match(/\A<time.+?data-in-words=\"noon\".+?<\/time>\z/)
    end

    it 'adds midnight as data-in-words if time is midnight' do
      _(semantic_date_time_tag(date_time_object_midnight)).must_match(/\A<time.+?data-in-words=\"midnight\".+?<\/time>\z/)
    end

    it 'adds locale class' do
      _(semantic_date_time_tag(date_time_object)).must_match(/class=\".+\s#{I18n.locale}\s.+\"/i)
    end

    it 'allows to pass :format' do
      _(semantic_date_time_tag(date_time_object, format: :test)).must_include '~'
      _(semantic_date_time_tag(date_time_object, format: :test)).must_include 'data-format="test"'
      _(semantic_date_time_tag(date_time_object, format: '%a, %b %-d, %Y, %-l:%M %P')).must_include 'data-format="%a, %b %-d, %Y, %-l:%M %P"'
      _(semantic_date_time_tag(date_time_object, format: '%a, %b %-d, %Y, %-l:%M %P')).wont_include ' format='
    end
  end
end
