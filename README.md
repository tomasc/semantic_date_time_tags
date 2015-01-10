# Semantic DateTime Tags

[![Build Status](https://travis-ci.org/tomasc/semantic_date_time_tags.svg)](https://travis-ci.org/tomasc/semantic_date_time_tags) [![Gem Version](https://badge.fury.io/rb/semantic_date_time_tags.svg)](http://badge.fury.io/rb/semantic_date_time_tags) [![Coverage Status](https://img.shields.io/coveralls/tomasc/semantic_date_time_tags.svg)](https://coveralls.io/r/tomasc/semantic_date_time_tags)

Set of Rails helpers that mark up Date, DateTime instances and their ranges with sensible combination of (html5) tags, data attributes and CSS classes so that their display can be easily controlled via CSS.

The generated markup takes into account Date/Time formats as specified in the [I18n localizations](http://guides.rubyonrails.org/i18n.html#adding-date-time-formats).

This allows, for example, highlighting today's dates:

```css
time.date.semantic.current_date {
  background-color: yellow;
}
```

Hiding current year via CSS:

```css
time.date.semantic.current_year {
  span.year {
    display: none;
  }
}
```

Or, in the case of date ranges, avoiding repetition of year in both dates:

```css
span.date_range.semantic.same_year {
  time.date.semantic.from {
    span.year {
      display: none;
    }
  }
}
```

See the included [SCSS example](/lib/assets/stylesheets/semantic_date_time_tags.css.scss) for more.

## Installation

Add this line to your application's Gemfile:

```Ruby
gem 'semantic_date_time_tags'
```

And then execute:

```
$ bundle
```

Or install it yourself as:

```
$ gem install semantic_date_time_tags
```

If you want to use the default css you can include it like this:
```
*= require 'semantic_date_time_tags'
```

## Usage

In your views:

### Date

```Ruby
<%= semantic_date_tag(Date.today) %>
```

Will result in the following markup:

```HTML
<time class="date semantic current_date current_year" datetime="2014-09-26">
  <span class="day d">26</span><span class="sep">.</span><span class="month m">9</span><span class="sep">.</span><span class="year Y">2014</span>
</time>
```

### DateTime

```Ruby
<%= semantic_date_time_tag(DateTime.now) %>
```

Will result in the following markup:

```HTML
<time class="date_time semantic current_date current_year" datetime="2014-09-26T15:35:56+02:00">
  <span class="day d">26</span><span class="sep">.</span><span class="month m">9</span><span class="sep">.</span><span class="year Y">2014</span> <span class="hours H">15</span><span class="sep">:</span><span class="minutes M">35</span>
</time>
```

### Date Range

```Ruby
<%= semantic_date_range_tag(Date.today, Date.tomorrow) %>
```

Will result in the following markup:

```HTML
<span class="date_range semantic same_year same_month">
  <time class="date semantic current_date current_year from">
    <span class="day d">26</span><span class="sep">.</span><span class="month m">9</span><span class="sep">.</span><span class="year Y">2014</span>
  </time>
  <span class="date_range_separator"> – </span>
  <time class="date semantic current_year to">
    <span class="day d">27</span><span class="sep">.</span><span class="month m">9</span><span class="sep">.</span><span class="year Y">2014</span>
  </time>
</span>
```

## Contributing

1. Fork it ( https://github.com/tomasc/semantic_date_time_tags/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
