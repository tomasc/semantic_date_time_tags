require 'semantic_date_time_tags/format_parser'
require 'test_helper'

module SemanticDateTimeTags
  describe FormatParser do

    describe '#to_html' do
      it 'wraps the components into span tags' do
        format = '%d / %m / %Y'
        string = '12 / 12 / 2014'
        res = FormatParser.new(format, string).to_html
        res.must_equal '<span class="day d">12</span> <span class="sep">/</span> <span class="month m">12</span> <span class="sep">/</span> <span class="year Y">2014</span>'
      end
    end

  end
end
