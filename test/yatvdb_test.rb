require_relative "test_helper"
require 'yatvdb'

describe YATVDB do
  before do
    FakeWeb.register_uri(:get,
      'http://thetvdb.com/api/GetSeries.php?seriesname=Justified&language=en',
      body: File.read(File.expand_path("../fixtures/justified.xml", __FILE__)),
      status: 200)
  end
end
