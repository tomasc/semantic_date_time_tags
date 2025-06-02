# CHANGELOG

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
