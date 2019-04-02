# ActiveSupport::Duration::HumanString

Convert [ActiveSupport::Duration](https://api.rubyonrails.org/classes/ActiveSupport/Duration.html) objects to human-friendly strings like `'2h 30m 17s'`.
Like [`distance_of_time_in_words`](https://api.rubyonrails.org/classes/ActionView/Helpers/DateHelper.html) helper but _exact_ rather than approximate.
Like `#inspect` but more concise. Like `#iso8601` but more human readable rather than machine readable.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'activesupport-duration-human_string'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install activesupport-duration-human_string

## Usage

```ruby
      duration = ActiveSupport::Duration.build(95)
      duration.human_to_s # => '1m 35s'
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/TylerRick/activesupport-duration-human_string.

##  Not really related

- https://github.com/josedonizetti/ruby-duration
- https://github.com/janko/as-duration
