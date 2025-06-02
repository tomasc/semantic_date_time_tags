# Semantic DateTime Tags

[![Gem Version](https://badge.fury.io/rb/semantic_date_time_tags.svg)](http://badge.fury.io/rb/semantic_date_time_tags)

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

### Time

```Ruby
<%= semantic_time_tag(Time.now) %>
```

Will result in the following markup:

```HTML
<time class="time semantic pm" datetime="15:35:56">
  <span class="hours H">15</span><span class="sep">:</span><span class="minutes M">35</span><span class="sep">:</span><span class="seconds S">56</span>
</time>
```

For special times like noon or midnight:

```HTML
<time class="time semantic am whole_hour noon" datetime="12:00:00" data-in-words="noon">
  <span class="hours H">12</span><span class="sep">:</span><span class="minutes M">00</span>
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

### ARIA Attributes (v0.3.0+)

All helpers support ARIA attributes for improved accessibility:

```Ruby
<%= semantic_date_tag(Date.today, aria: { label: "Today's date", describedby: "calendar-help" }) %>
```

For date ranges with open ends:

```Ruby
<%= semantic_date_range_tag(Date.today, nil) %>
<!-- Automatically adds aria-label="From December 31, 2024" -->
```

### Additional Options

- **Format**: Use a specific I18n format key: `format: :long`
- **Locale**: Override current locale: `locale: :de`
- **Separator**: Custom date range separator: `separator: " to "`
- **Time components**: The format parser supports seconds (`%S`) and milliseconds (`%L`)

**Note**: `semantic_date_time_range_tag` is an alias for `semantic_date_range_tag`.

## Contributing

1. Fork it ( https://github.com/tomasc/semantic_date_time_tags/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
