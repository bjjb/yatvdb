# Yatvdb

Yet another API client for TheTVDB. This one caches responses locally, and
exposes a couple of classes to represent the data, if you don't like tearing
through hashes.

## Installation

Add this line to your application's Gemfile:

    gem 'yatvdb'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install yatvdb

## Usage

```ruby
# Search for the TV series "Justified"
require 'yatvdb/client'
client = YATVDB::Client.new(api_key: 'My API key', cache: '/path/to/cache')
results = client.get_series('Justified') # => [<YATVDB::Series...>]
justified = results.first
justified.overview # => "Deputy U.S. Marshal Raylan Givens is..."
justified.episodes # => [<YATVDB::Episode @name="Fire in the Hole"...>, ...]
justified.seasons # => [<YATVDB::Season @number=1...>, ...]
```

## Configuration

YATVDB will look for a YAML or Ruby configuration file in:

1. ./.yatvdb/config.{yml,rb}
2. ~/config/yatvdb.{yml,rb}
3. /usr/local/etc/yatvdb.conf
4. /etc/yatvdb.conf

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
