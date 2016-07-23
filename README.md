# HaarJoke

<img src="https://travis-ci.org/pveggie/haarjoke.svg?branch=master">

HaarJoke can be used to create Chuck Norris type jokes featuring Haar.

<img src="http://vignette2.wikia.nocookie.net/fireemblem/images/f/fb/Haar.jpg/revision/latest?cb=20090813131313">

* Haar is a character from Fire Emblem: Path of Radiance and Fire Emblem:
Radiant Dawn. He is know for being badass even while sleeping. Haar does not
kill enemies; enemies kill themselves on Haar.

<a href="http://www.gamefaqs.com/boards/932999-fire-emblem-radiant-dawn/41201620">http://www.gamefaqs.com/boards/932999-fire-emblem-radiant-dawn/41201620</a>

Jokes are taken from The Internet Chuck Norris Database
<a href="http://www.icndb.com/api/">(http://www.icndb.com/api/)</a>

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'haar_joke'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install haar_joke

## Usage

You can generate a default Haar joke.

```ruby
HaarJoke.create_joke
```

You can also customise the joke to feature someone other than Haar,
to substitute terms of your choice, and to filter out jokes based on terms.

```ruby
HaarJoke.create_custom_joke
```

This requires a YAML file listing filters and substituions at
config/haar_joke.yml

Example (No jokes about milk. Chuck Norris to be replaced by Brian):
```yaml
filters:
  - milk
substitutions:
  chuck norrises: Brians
  chuck norris': Brian's
  chuck norris: Brian
```


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/pveggie/haarjoke.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

