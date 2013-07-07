require_relative "test_helper"
require 'yatvdb'
require 'tmpdir'

describe YATVDB do
  before do
    @tmpdir = Dir.mktmpdir("yatvdb_test")

    YATVDB.cache_path = Pathname.new(@tmpdir)
    YATVDB.api_key = "FOOBAR"

    FakeWeb.register_uri(:get,
      'http://thetvdb.com/api/GetSeries.php?seriesname=Justified&language=en',
      body: File.read(File.expand_path("../fixtures/justified.xml", __FILE__)),
      status: 200)

    FakeWeb.register_uri(:get,
      'http://thetvdb.com/api/FOOBAR/series/134241/en.xml',
      body: File.read(File.expand_path("../fixtures/series/134241/en.xml", __FILE__)),
      status: 200)

    FakeWeb.register_uri(
      :get,
      "http://thetvdb.com/api/FOOBAR/series/134241/all/en.xml",
      body: Pathname.new(__FILE__).expand_path.join('../fixtures/series/134241/all/en.xml').read
    )
  end

  after do
    FileUtils.rm_r(@tmpdir)
  end

  it "has an api key" do
    YATVDB.api_key.wont_be_nil
  end

  it "can find a TV series" do
    results = YATVDB.find_series "Justified"
    series = results.first
    series.id.must_equal 134241
  end

  it "can fetch and cache a TV series" do
    YATVDB.cache_path.join('series/134241/en.xml').wont_be :exist?
    series = YATVDB.fetch('series/134241/en.xml')
    YATVDB.cache_path.join('series/134241/en.xml').must_be :exist?
    # FakeWeb will complain if not cached
    series = YATVDB.fetch_series('series/134241/en.xml')
    series.must_be_kind_of YATVDB::Series
  end

  it "can fetch complete series data" do
    result = YATVDB.fetch_series("series/134241/all/en.xml")
    result.must_be_kind_of YATVDB::Series
    result.name.must_equal 'Justified'
  end
end
