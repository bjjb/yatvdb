require_relative '../test_helper'
require 'yatvdb/find'

describe YATVDB::Find do
  subject do
    Struct.new(:language) do
      include YATVDB::Find
    end.new(:de)
  end

  it "can find a series" do
    subject.must_respond_to :find_series
  end

  it "finds a series based on the name" do
    FakeWeb.register_uri(
      :get,
      "http://thetvdb.com/api/GetSeries.php?seriesname=Justified&language=de",
      body: "<Data><Series><id>123</id><name>Justified</name></Series></Data>"
    )
    subject.find_series("Justified").first.name.must_equal 'Justified'
  end
end
