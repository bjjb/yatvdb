require_relative "../test_helper"
require 'yatvdb/series'

describe YATVDB::Series do

  it "can be loaded from the cache" do
    xml = MiniTest::Mock.new
    xml.expect :elements, []
    series = YATVDB::Series.new(xml)
    series.series_id = 134241
    series.language = "en"
    series.series_id.must_equal 134241
    series.cache.must_equal Pathname.new(__FILE__).join("../../fixtures/series/134241/all/en.xml").expand_path
    series.fetch!
    series.name.must_equal "Justified"
  end
end
