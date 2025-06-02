require 'benchmark'
require_relative '../test/test_helper'

# Sample formats and strings for benchmarking
FORMATS = [
  "%Y-%m-%d",
  "%B %d, %Y",
  "%Y-%m-%d %H:%M:%S",
  "%A, %B %d, %Y at %I:%M %p",
  "%d.%m.%Y %H:%M"
]

SAMPLE_STRINGS = [
  "2024-01-15",
  "January 15, 2024",
  "2024-01-15 14:30:45",
  "Monday, January 15, 2024 at 02:30 PM",
  "15.01.2024 14:30"
]

ITERATIONS = 10_000

puts "Benchmarking OPTIMIZED FormatParser performance (#{ITERATIONS} iterations per format)..."
puts "=" * 60

# Clear caches before benchmarking
SemanticDateTimeTags::FormatParser::COMPONENT_REGEX_CACHE.clear
SemanticDateTimeTags::FormatParser::COMPONENT_CLASSES_CACHE.clear

FORMATS.each_with_index do |format, i|
  # Clear caches between format tests for fair comparison
  SemanticDateTimeTags::FormatParser::COMPONENT_REGEX_CACHE.clear
  SemanticDateTimeTags::FormatParser::COMPONENT_CLASSES_CACHE.clear

  time = Benchmark.realtime do
    ITERATIONS.times do
      parser = SemanticDateTimeTags::FormatParser.new(format, SAMPLE_STRINGS[i])
      parser.to_html
    end
  end

  puts "Format: #{format}"
  puts "  Total time: #{(time * 1000).round(2)}ms"
  puts "  Average per iteration: #{(time * 1000 / ITERATIONS).round(4)}ms"
  puts
end

puts "\nCache effectiveness test..."
puts "=" * 60

# Test with warmed cache
format = "%Y-%m-%d %H:%M:%S"
str = "2024-01-15 14:30:45"

# Clear cache
SemanticDateTimeTags::FormatParser::COMPONENT_REGEX_CACHE.clear
SemanticDateTimeTags::FormatParser::COMPONENT_CLASSES_CACHE.clear

# First run (cold cache)
cold_time = Benchmark.realtime do
  1000.times do
    parser = SemanticDateTimeTags::FormatParser.new(format, str)
    parser.to_html
  end
end

# Subsequent runs (warm cache)
warm_time = Benchmark.realtime do
  1000.times do
    parser = SemanticDateTimeTags::FormatParser.new(format, str)
    parser.to_html
  end
end

puts "Cold cache (first 1000 iterations): #{(cold_time * 1000).round(2)}ms"
puts "Warm cache (next 1000 iterations): #{(warm_time * 1000).round(2)}ms"
puts "Improvement: #{((1 - warm_time/cold_time) * 100).round(1)}%"

puts "\nCache sizes after benchmark:"
puts "  Regex cache: #{SemanticDateTimeTags::FormatParser::COMPONENT_REGEX_CACHE.size} entries"
puts "  Classes cache: #{SemanticDateTimeTags::FormatParser::COMPONENT_CLASSES_CACHE.size} entries"
