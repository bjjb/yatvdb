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
justified.seasons # => [[<YATVDB::Episode @name="Fire in the Hole"...>...], ...]
```

## Configuration

YATVDB will look for a YAML or Ruby configuration file in:

1. /config/yatvdb.yml
2. ~/.yatvdb/config
3. /usr/local/etc/yatvdb.conf
4. /etc/yatvdb.conf

The file should be a simple YAML configuration, like

```yaml
---
api_key: 1234567890
cache: /var/db/yatvdb
```

## Caching

If a cache path can be determined (and it points to a writeable directory), then
it will be used to mirror the thetvdb.com. Lookups will first try to find the
files in that directory, before downloading them and caching them there. If
caching is enabled, then you should remember to run the utility
`YATVDB.expire_cache` method occasionally to get the latest changes (it will
check for updates on the server, and just delete outdated cache files).

## Caveats/TODOs

* [ ] Make the XML parsing pluggable ([REXML][rexml], [Nokogiri][nokogiri])
* [ ] See about always getting the zipped files
* [ ] Export to JSON/Ruby
* [ ] Basic fetch/output command-line interface
* [ ] More tests and documentation


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

[rexml][http://www.germane-software.com/software/rexml/]
[nokogiri][http://nokogiri.org/]
