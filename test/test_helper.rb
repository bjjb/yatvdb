require 'minitest/autorun'
require 'pathname'
require 'fakeweb'
require 'yatvdb'

FakeWeb.allow_net_connect = false

FakeWeb.register_uri(
  :get,
  'http://thetvdb.com/api/GetSeries.php?seriesname=Justified&language=en',
  body: File.read(File.expand_path("../fixtures/justified.xml", __FILE__)),
  status: 200
)

FakeWeb.register_uri(
  :get,
  'http://thetvdb.com/api/FOOBAR/series/134241/en.xml',
  body: File.read(File.expand_path("../fixtures/series/134241/en.xml", __FILE__)),
  status: 200
)

FakeWeb.register_uri(
  :get,
  "http://thetvdb.com/api/FOOBAR/series/134241/all/en.xml",
  body: File.read(File.expand_path("../fixtures/series/134241/all/en.xml", __FILE__)),
  status: 200
)

class MiniTest::Test
  def setup
    @tmpdir = Dir.mktmpdir
    YATVDB.cache_path = @tmpdir
    YATVDB.api_key = 'FOOBAR'
  end

  def teardown
    FileUtils.rm_r @tmpdir
  end
end
