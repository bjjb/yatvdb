require 'minitest/autorun'
require 'fakeweb'
require 'yatvdb'

YATVDB.api_key = 'FAKE_KEY'
YATVDB.cache = File.expand_path("../fixtures", __FILE__)
puts YATVDB.cache
FakeWeb.allow_net_connect = false
