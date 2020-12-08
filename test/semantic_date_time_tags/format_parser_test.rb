# frozen_string_literal: true

require "semantic_date_time_tags/format_parser"
require "test_helper"

describe SemanticDateTimeTags::FormatParser do
  subject { SemanticDateTimeTags::FormatParser.new(format, string) }
  let(:to_html) { subject.to_html }

  describe "#to_html" do
    describe "d / m / Y" do
      let(:format) { "%d / %m / %Y" }
      let(:string) { "12 / 12 / 2014" }

      it "wraps the components into span tags" do
        _(to_html).must_equal '<span class="day d">12</span><span class="sep"> / </span><span class="month m">12</span><span class="sep"> / </span><span class="year Y">2014</span>'
      end
    end

    describe "d m Y" do
      let(:format) { "%-d %b %Y" }
      let(:string) { "12 December 2014" }

      it "wraps the components into span tags" do
        _(to_html).must_equal '<span class="day d">12</span><span class="sep"> </span><span class="month b">December</span><span class="sep"> </span><span class="year Y">2014</span>'
      end
    end

    describe "d / m / Y" do
      let(:format) { "%I.%M %p" }
      let(:string) { "10.00 AM" }

      it "wraps the components into span tags" do
        _(to_html).must_equal '<span class="hours I">10</span><span class="sep">.</span><span class="minutes M">00</span><span class="sep"> </span><span class="ampm p">AM</span>'
      end
    end

    describe "d / m / Y" do
      let(:format) { "%a, %b %e, %Y" }
      let(:string) { "Sun, Jan 1, 2015" }

      it "wraps the components into span tags" do
        _(to_html).must_equal '<span class="day a">Sun</span><span class="sep">, </span><span class="month b">Jan</span><span class="sep"> </span><span class="day e">1</span><span class="sep">, </span><span class="year Y">2015</span>'
      end
    end

    describe "A d / m / Y" do
      let(:format) { "%A %d / %m / %Y" }
      let(:string) { "Saturday 12 / 12 / 2014" }

      it "wraps the components into span tags" do
        _(to_html).must_equal '<span class="day A">Saturday</span><span class="sep"> </span><span class="day d">12</span><span class="sep"> / </span><span class="month m">12</span><span class="sep"> / </span><span class="year Y">2014</span>'
      end
    end

    describe "%-l:%M %P" do
      let(:format) { "%-l:%M %P" }
      let(:string) { "12:30 am" }

      it "marks up the am/pm" do
        _(to_html).must_include '<span class="ampm P">'
      end
    end

    describe ":cs" do
      let(:format) { "%A, %-d. %B, %Y" }
      let(:string) { "Čtvrtek, 16. Červen, 2016" }

      it "deals fine with accented characters" do
        _(to_html).must_equal "<span class=\"day A\">Čtvrtek</span><span class=\"sep\">, </span><span class=\"day d\">16</span><span class=\"sep\">. </span><span class=\"month B\">Červen</span><span class=\"sep\">, </span><span class=\"year Y\">2016</span>"
      end
    end

    describe "additional string" do
      let(:format) { "%d.%m.%Y %H.%M hrs" }
      let(:string) { "09.09.2014 19.00 hrs" }

      it "preserves additional strings" do
        _(to_html).must_equal "<span class=\"day d\">09</span><span class=\"sep\">.</span><span class=\"month m\">09</span><span class=\"sep\">.</span><span class=\"year Y\">2014</span><span class=\"sep\"> </span><span class=\"hours H\">19</span><span class=\"sep\">.</span><span class=\"minutes M\">00</span><span class=\"str\"> hrs</span>"
      end
    end
  end
end
