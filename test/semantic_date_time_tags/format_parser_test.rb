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
      let(:string) { "Sun, Jan  1, 2015" }

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

    describe "blank padded formats" do
      # Day of the month (1..31)
      describe "%e" do
        it "handles blank paddded results" do
          format = "%a, %e %b, %Y %H:%M"
          string = "Thu,  3 Apr, 2025 20:30"
          _(SemanticDateTimeTags::FormatParser.new(format, string).to_html).wont_match(/\<span class\=\"str\">0\<\/span\>/)
        end

        it "handles non blank padded results" do
          date = Date.new(2025, 4, 30)
          format = "%e %b, %Y"
          string = I18n.localize(date, format: format)
          _(SemanticDateTimeTags::FormatParser.new(format, string).to_html).must_equal '<span class="day e">30</span><span class="sep"> </span><span class="month b">Apr</span><span class="sep">, </span><span class="year Y">2025</span>'
        end
      end

      # Hour of the day, 24-hour clock
      describe "%k" do
        it "handles blank padded results" do
          format = "%d.%m.%Y %k:%M"
          string = "03.04.2025  4:30"
          _(SemanticDateTimeTags::FormatParser.new(format, string).to_html).must_equal '<span class="day d">03</span><span class="sep">.</span><span class="month m">04</span><span class="sep">.</span><span class="year Y">2025</span><span class="sep"> </span><span class="hours k">4</span><span class="sep">:</span><span class="minutes M">30</span>'
        end

        it "handles non blank padded results" do
          format = "%d.%m.%Y %k:%M"
          string = "03.04.2025 10:30"
          _(SemanticDateTimeTags::FormatParser.new(format, string).to_html).must_equal '<span class="day d">03</span><span class="sep">.</span><span class="month m">04</span><span class="sep">.</span><span class="year Y">2025</span><span class="sep"> </span><span class="hours k">10</span><span class="sep">:</span><span class="minutes M">30</span>'
        end
      end

      # Hour of the day, 12-hour clock
      describe "%l" do
        it "handles blank padded results" do
          format = "%d.%m.%Y %l.%M %P"
          string = "03.04.2025  8.30 pm"
          _(SemanticDateTimeTags::FormatParser.new(format, string).to_html).must_equal '<span class="day d">03</span><span class="sep">.</span><span class="month m">04</span><span class="sep">.</span><span class="year Y">2025</span><span class="sep"> </span><span class="hours l">8</span><span class="sep">.</span><span class="minutes M">30</span><span class="sep"> </span><span class="ampm P">pm</span>'
        end

        it "handles non blank padded results" do
          format = "%d.%m.%Y %l.%M %P"
          string = "03.04.2025 10.30 am"
          _(SemanticDateTimeTags::FormatParser.new(format, string).to_html).must_equal '<span class="day d">03</span><span class="sep">.</span><span class="month m">04</span><span class="sep">.</span><span class="year Y">2025</span><span class="sep"> </span><span class="hours l">10</span><span class="sep">.</span><span class="minutes M">30</span><span class="sep"> </span><span class="ampm P">am</span>'
        end
      end
    end
  end
end
