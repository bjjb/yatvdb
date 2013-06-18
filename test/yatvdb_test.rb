require_relative "test_helper"
require 'yatvdb'

describe YATVDB do
  before do
    FakeWeb.register_uri :get,
      'http://thetvdb.com/api/GetSeries.php?seriesname=Justified&language=en',
      body: File.read(File.expand_path("../fixtures/justified.xml", __FILE__)),
      status: 200
  end

  it "can have an API key" do
    YATVDB.api_key
  end

  it "can get a series data" do
    series = YATVDB.get_series('Justified')
    series.must_be_kind_of Array
    series = series.first
    series.name.must_equal 'Justified'
  end
end
