require 'semantic_date_time_tags/format_parser'
require 'test_helper'

module SemanticDateTimeTags
  describe FormatParser do

    subject { FormatParser.new(format, string) }
    let(:to_html) { subject.to_html }

    describe '#to_html' do
      describe 'd / m / Y' do
        let(:format) { '%d / %m / %Y' }
        let(:string) { '12 / 12 / 2014' }

        it 'wraps the components into span tags' do
          to_html.must_equal '<span class="day d">12</span> <span class="sep">/</span> <span class="month m">12</span> <span class="sep">/</span> <span class="year Y">2014</span>'
        end
      end

      describe 'd / m / Y' do
        let(:format) { '%I.%M %p' }
        let(:string) { '10.00 AM' }

        it 'wraps the components into span tags' do
          to_html.must_equal '<span class="hours I">10</span><span class="sep">.</span><span class="minutes M">00</span> <span class="ampm p">AM</span>'
        end
      end

    end
  end
end
