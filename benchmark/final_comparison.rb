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

ITERATIONS = 50_000

puts "Final Performance Comparison (#{ITERATIONS} iterations per format)"
puts "=" * 80
puts

total_time = 0

FORMATS.each_with_index do |format, i|
  # Clear all caches
  SemanticDateTimeTags::FormatParser::COMPONENT_REGEX_CACHE.clear
  SemanticDateTimeTags::FormatParser::COMPONENT_CLASSES_CACHE.clear
  SemanticDateTimeTags::FormatParser::FORMAT_COMPONENTS_CACHE.clear

  time = Benchmark.realtime do
    ITERATIONS.times do
      parser = SemanticDateTimeTags::FormatParser.new(format, SAMPLE_STRINGS[i])
      parser.to_html
    end
  end

  total_time += time

  puts "Format: #{format}"
  puts "  Total time: #{(time * 1000).round(2)}ms"
  puts "  Average per iteration: #{(time * 1000 / ITERATIONS).round(4)}ms"
  puts "  Throughput: #{(ITERATIONS / time).round(0)} operations/second"
  puts
end

puts "-" * 80
puts "Total time for all formats: #{(total_time * 1000).round(2)}ms"
puts "Average throughput: #{((ITERATIONS * FORMATS.size) / total_time).round(0)} operations/second"

puts "\n\nCache Effectiveness Analysis"
puts "=" * 80

# Test repeated parsing of same format
format = "%Y-%m-%d %H:%M:%S"
dates = (1..100).map { |i| "2024-01-#{i.to_s.rjust(2, '0')} 14:30:45" }

# Clear caches
SemanticDateTimeTags::FormatParser::COMPONENT_REGEX_CACHE.clear
SemanticDateTimeTags::FormatParser::COMPONENT_CLASSES_CACHE.clear
SemanticDateTimeTags::FormatParser::FORMAT_COMPONENTS_CACHE.clear

time = Benchmark.realtime do
  1000.times do
    dates.each do |date|
      parser = SemanticDateTimeTags::FormatParser.new(format, date)
      parser.to_html
    end
  end
end

puts "Parsing 100 different dates with same format, 1000 times each:"
puts "  Total time: #{(time * 1000).round(2)}ms"
puts "  Average per parse: #{(time * 1000 / 100_000).round(4)}ms"
puts "  Throughput: #{(100_000 / time).round(0)} operations/second"

puts "\nFinal cache statistics:"
puts "  Format components cache: #{SemanticDateTimeTags::FormatParser::FORMAT_COMPONENTS_CACHE.size} entries"
puts "  Regex cache: #{SemanticDateTimeTags::FormatParser::COMPONENT_REGEX_CACHE.size} entries"
puts "  Classes cache: #{SemanticDateTimeTags::FormatParser::COMPONENT_CLASSES_CACHE.size} entries"

puts "\n\nMemory Usage Estimate"
puts "=" * 80

# Rough memory estimate
format_cache_size = SemanticDateTimeTags::FormatParser::FORMAT_COMPONENTS_CACHE.size * 200 # bytes per format
regex_cache_size = SemanticDateTimeTags::FormatParser::COMPONENT_REGEX_CACHE.size * 100 # bytes per regex
class_cache_size = SemanticDateTimeTags::FormatParser::COMPONENT_CLASSES_CACHE.size * 50 # bytes per class array

total_cache_memory = format_cache_size + regex_cache_size + class_cache_size

puts "Estimated cache memory usage: #{total_cache_memory} bytes (~#{(total_cache_memory / 1024.0).round(2)} KB)"
puts "Cache efficiency: #{(100_000.0 / total_cache_memory * 1000).round(2)} operations per KB of cache"
