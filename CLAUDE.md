# CLAUDE.md - AI Assistant Context for semantic_date_time_tags

## Project Overview

`semantic_date_time_tags` is a Ruby gem that provides Rails view helpers for rendering dates, times, and date ranges with semantic HTML5 markup. The gem wraps date/time information in appropriate HTML tags with CSS classes and data attributes, making it easy to style dates contextually via CSS.

### Key Features
- Semantic HTML5 `<time>` tags with proper datetime attributes
- CSS classes for targeting specific date components (year, month, day, hours, minutes)
- Contextual classes (current_date, current_year, same_year, same_month)
- I18n support for date/time formatting
- Support for date ranges with intelligent CSS classes

## Technical Details

- **Ruby Version**: 3.3.5
- **Rails Dependency**: Yes (uses Rails view helpers and I18n)
- **Testing Framework**: Minitest
- **Code Style**: Rubocop with rails-omakase configuration

## Project Structure

```
semantic_date_time_tags/
├── lib/
│   ├── semantic_date_time_tags/
│   │   ├── tag/               # Tag classes for different date/time types
│   │   ├── format_parser.rb    # Parses I18n format strings into HTML
│   │   ├── view_helpers.rb     # Rails view helper methods
│   │   └── version.rb
├── test/                       # Test files
└── semantic_date_time_tags.gemspec
```

## Core Components

### View Helpers
- `semantic_date_tag(date, options = {})` - For Date objects
- `semantic_time_tag(time, options = {})` - For Time objects  
- `semantic_date_time_tag(datetime, options = {})` - For DateTime objects
- `semantic_date_range_tag(from, to, options = {})` - For date/time ranges

### CSS Classes Applied
- **Structural**: `semantic`, `date`, `time`, `date_time`, `date_range`
- **Components**: `year`, `month`, `day`, `hours`, `minutes`, `seconds`
- **Contextual**: `current_date`, `current_year`, `same_year`, `same_month`, `whole_hour`, `noon`, `midnight`, `am`/`pm`
- **Locale**: Current I18n locale (e.g., `en`)

### FormatParser
Converts I18n date/time format strings into semantic HTML by:
1. Parsing format components (e.g., `%Y`, `%m`, `%d`)
2. Wrapping each component in appropriate `<span>` tags
3. Preserving separators and additional text

## Common Tasks

### Adding a New Format Component
1. Update `FormatParser#get_classes_for_component` to handle the new format code
2. Update `FormatParser#get_regexp_for_component` if needed for special matching
3. Add tests in `format_parser_test.rb`

### Adding a New CSS Class
1. Update the relevant tag class (Date, Time, DateTime, or DateRange)
2. Add the logic to the appropriate method (e.g., `dom_classes`)
3. Add corresponding tests

## Testing Guidelines

Run tests with: `bundle exec rake test`

Test files follow the pattern:
- One file per view helper method
- Test various date/time scenarios (current date, different years, noon/midnight)
- Verify HTML structure and CSS classes
- Check I18n format handling

## I18n Configuration

The gem includes default formats in `lib/config/locales/`:
- `full`: Default format for dates and times
- `test`: Test format using different separators
- Special words like "noon" and "midnight"

Users can override by adding their own locale files with the same keys.

## Development Workflow

1. Update code following Ruby style guide (enforced by Rubocop)
2. Add/update tests for any changes
3. Run `bundle exec rake test` to ensure all tests pass
4. Update CHANGELOG.md for any user-facing changes
5. Bump version in `version.rb` following semantic versioning

## Known Patterns & Best Practices

1. **Separation of Concerns**: Each tag type has its own class
2. **Format String Parsing**: Complex regex patterns handle various format codes
3. **CSS-First Philosophy**: The gem focuses on providing hooks for CSS styling
4. **I18n Integration**: All formatting respects Rails I18n configuration
5. **Semantic HTML**: Proper use of HTML5 `<time>` elements with datetime attributes

## Potential Improvements

1. Support for additional HTML5 time element features
2. More comprehensive timezone handling
3. JavaScript integration for dynamic updates
4. ~~Performance optimizations for format parsing~~ ✅ Completed in v0.3.1 (#40)

## Debugging Tips

- Check generated HTML structure if styling isn't working
- Verify I18n format strings are correctly defined
- Inspect data attributes for format and in-words values
