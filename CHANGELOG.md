# CHANGELOG

## 0.4.1

* feat: add nil handling to all view helpers (#43, fixes #6)
  * `semantic_date_tag(nil)` now returns `nil` instead of raising error
  * `semantic_time_tag(nil)` now returns `nil` instead of raising error
  * `semantic_date_time_tag(nil)` now returns `nil` instead of raising error
  * `semantic_date_range_tag(nil, ...)` now returns `nil` instead of raising error
  * maintains existing validation for invalid object types
  * comprehensive test coverage for nil handling behavior

## 0.4.0

* BREAKING: Remove all SCSS/CSS stylesheets from gem (#41)
  * Gem now purely focuses on generating semantic HTML markup
  * Users have complete control over styling without opinionated defaults
  * All CSS classes remain unchanged for backward compatibility
* docs: Add missing `semantic_time_tag` documentation
* docs: Document ARIA attributes support
* docs: Document seconds/milliseconds format support

## 0.3.1

* feat: significant performance optimizations for FormatParser (#40)
  * 40-50% faster parsing through regex and component caching
  * minimal memory footprint (~1.5KB cache)
  * no API changes or breaking changes

## 0.3.0

* feat: add ARIA attribute support for better accessibility (#39)
  * automatic aria-label generation for all date/time tags
  * support custom ARIA attributes via `aria: { label: "...", describedby: "..." }` option
  * properly handle open-ended date ranges (nil date_to)
* fix: Rails 8.1 deprecation warning for `to_time` method
* fix: regex ambiguity warnings in tests

## 0.2.2

* update to Ruby 3.3.5
* fix: format parser messes up blank padding formats (@asgerb)

## 0.2.1

* modernize the overall setup of this gem, update to Ruby 3.3.4
* handle missing format string

## 0.2.0

* added possibility to pass in data attributes to both `time` and `span` tags (date range)

## 0.1.19

* removed `:format` from options passed to the `time` tag (in effect producing invalid HTML)

## 0.1.18

* removed `:separator` from options passed to the `time` tag (in effect producing invalid HTML)
