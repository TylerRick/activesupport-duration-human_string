# ActiveSupport::Duration#human_string  [![Gem Version](https://badge.fury.io/rb/activesupport-duration-human_string.svg)](https://badge.fury.io/rb/activesupport-duration-human_string)

Convert [ActiveSupport::Duration](https://api.rubyonrails.org/classes/ActiveSupport/Duration.html) objects to human-friendly strings like `'2h 30m 17s'`.

- Like [`distance_of_time_in_words`](https://api.rubyonrails.org/classes/ActionView/Helpers/DateHelper.html#method-i-distance_of_time_in_words)
  helper but _exact_ rather than approximate
  - `distance_of_time_in_words` is somewhat configurable but only gives an approximation (`'over 3
    years'`), with no option to print the exact number of each units.
- Like [`#inspect`](https://github.com/rails/rails/blob/b9ca94caea2ca6a6cc09abaffaad67b447134079/activesupport/lib/active_support/duration.rb#L372)
  but more concise and configurable.
  - `#inspect` is long (`'3 years, 6 months, 4 days, 12 hours, 30 minutes, and 5 seconds'`) and not
    at all configurable.
- Like [`#iso8601`](https://api.rubyonrails.org/classes/ActiveSupport/Duration.html#method-i-iso8601)
  but more human readable rather than machine readable.
  - `#iso8601` is concise and machine-readable, but not very human-readable (`'P3Y6M4DT12H30M5S'`)!
- Unlike [`#to_s`](https://api.rubyonrails.org/classes/ActiveSupport/Duration.html#method-i-to_s),
  which is very concise (`'110839937'`) but not at all human-readable for large durations

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'activesupport-duration-human_string'
```

## Usage

```ruby
    duration = 3500.seconds
    duration.human_str                 # =>  '58m 20s'
    duration.human_str(delimiter: '')  # =>  '58m20s'
    duration.human_str(separator: ' ') # =>  '58 m 20 s'
    duration.human_str(delimiter: ', ', separator: ' ') # =>  '58 m, 20 s'

    duration = ActiveSupport::Duration.parse "P3Y6M4DT12H30M5S"
    # => 3 years, 6 months, 4 days, 12 hours, 30 minutes, and 5 seconds

    duration.human_str                  # => "3y 6m 4d 12h 30m 5s"
    (duration - 4.days).human_str       # => "3y 6m 12h 30m 5s"
    duration.human_str(delimiter: ', ') # => "3y, 6m, 4d, 12h, 30m, 5s"
```

Also aliased as `human_string`, `to_human_s`.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/TylerRick/activesupport-duration-human_string.

##  Not really related

- https://github.com/josedonizetti/ruby-duration
- https://github.com/janko/as-duration
