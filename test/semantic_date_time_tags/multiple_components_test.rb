# frozen_string_literal: true

require "test_helper"

describe SemanticDateTimeTags do
  include SemanticDateTimeTags::ViewHelpers

  let(:date) { Date.parse("2015-07-16") }

  describe "format with multiple components of same type" do
    it "correctly handles format with multiple year components" do
      I18n.locale = :en
      I18n.backend.store_translations :en, date: { formats: { multiple_years: "%Y %y" } }
      
      output = semantic_date_tag(date, format: :multiple_years).to_s
      
      # Both %Y and %y should be wrapped as year components
      assert_match %r{<span class="year Y">2015</span>}, output
      assert_match %r{<span class="year y">15</span>}, output
    end

    it "correctly handles the problematic format from issue #5" do
      I18n.locale = :en
      I18n.backend.store_translations :en, date: { formats: { issue_5: "%A %b %-d, %Y %y" } }
      
      output = semantic_date_tag(date, format: :issue_5).to_s
      
      # Verify each component is correctly wrapped (note: %A is classified as 'day' for backwards compatibility)
      assert_match %r{<span class="day A">Thursday</span>}, output
      assert_match %r{<span class="month b">Jul</span>}, output
      assert_match %r{<span class="day d">16</span>}, output
      assert_match %r{<span class="year Y">2015</span>}, output
      assert_match %r{<span class="year y">15</span>}, output
      
      # Ensure no components are misclassified as reported in issue #5
      refute_match %r{<span class="month b">Thursday</span>}, output
      refute_match %r{<span class="day d">Jul</span>}, output
      refute_match %r{<span class="year Y">6</span>}, output  # Should be "2015" not "6"
    end

    it "handles multiple day components" do
      I18n.locale = :en
      I18n.backend.store_translations :en, date: { formats: { multiple_days: "%d %e %-d" } }
      
      output = semantic_date_tag(date, format: :multiple_days).to_s
      
      assert_match %r{<span class="day d">16</span>}, output
      assert_match %r{<span class="day e">16</span>}, output
      # Verify the format string structure is preserved
      assert_match %r{<span class="day d">16</span><span class="sep"> </span><span class="day e">16</span><span class="sep"> </span><span class="day d">16</span>}, output
    end
    
    it "verifies issue #5 is resolved - no component misclassification" do
      # Test the exact problematic case from issue #5
      date_2015 = Date.parse("2015-07-16")
      I18n.locale = :en
      I18n.backend.store_translations :en, date: { formats: { issue_format: "%A %b %-d, %Y %y" } }
      
      output = semantic_date_tag(date_2015, format: :issue_format).to_s
      
      # The issue reported these problems:
      # 1. Thursday was classified as month (class="month b")
      # 2. Jul was classified as day (class="day d")  
      # 3. Year showed only "6" instead of full values
      
      # Verify these are all fixed:
      assert_match %r{Thursday}, output
      assert_match %r{Jul}, output
      assert_match %r{2015}, output
      assert_match %r{15}, output
      
      # Most importantly: verify no misclassification happens
      refute_match %r{class="month [^"]*">Thursday}, output
      refute_match %r{class="day [^"]*">Jul}, output
      refute_match %r{>6</span>}, output  # Year should not be truncated
    end
  end
end