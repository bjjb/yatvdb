require 'minitest/autorun'
require 'fakeweb'
require 'yatvdb'

YATVDB.api_key = 'FAKE_KEY'
YATVDB.cache_path = Pathname.new(__FILE__).join("../fixtures").expand_path

FakeWeb.allow_net_connect = false

class MiniTest::Test
  def fixture(file)
    YATVDB.cache.join(file)
  end
end
