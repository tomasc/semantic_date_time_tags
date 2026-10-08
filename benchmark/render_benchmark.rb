# frozen_string_literal: true

# Per-render cost of the tags as an event list row renders them.
#   bundle exec ruby benchmark/render_benchmark.rb
require_relative "../test/test_helper"

include SemanticDateTimeTags::ViewHelpers

date = Date.new(2026, 10, 8)
dtstart = DateTime.new(2026, 10, 8, 19, 0)
dtend = DateTime.new(2026, 10, 9, 21, 30)

CASES = {
  "Date" => -> { semantic_date_tag(date) },
  "DateTime" => -> { semantic_date_time_tag(dtstart) },
  "DateTimeRange" => -> { semantic_date_range_tag(dtstart, dtend) }
}.freeze

ITERATIONS = 20_000

CASES.each do |name, render|
  1_000.times { render.call }

  GC.start
  allocations = GC.stat(:total_allocated_objects)
  render.call
  allocations = GC.stat(:total_allocated_objects) - allocations

  started = Process.clock_gettime(Process::CLOCK_MONOTONIC)
  ITERATIONS.times { render.call }
  seconds = Process.clock_gettime(Process::CLOCK_MONOTONIC) - started

  puts format("%-14s %7.1f µs/render  %4d allocations", name, seconds * 1_000_000 / ITERATIONS, allocations)
end
