require_relative "test_helper"
require 'yatvdb'
require 'tmpdir'

describe YATVDB do
  it "has an api key" do
    YATVDB.api_key.must_equal 'FOOBAR'
  end

  it "can find a TV series" do
    results = YATVDB.find_series "Justified"
    results.must_be_kind_of Array
    results.each { |result| result.must_be_kind_of YATVDB::Series }
    series = results.first
    series.id.must_equal 134241
  end

  it "can fetch and cache a TV series" do
    YATVDB.cache_path.join('series/134241/all/en.xml').wont_be :readable?
    series = YATVDB.fetch_series(134241)
    YATVDB.cache_path.join('series/134241/all/en.xml').must_be :readable?
    series = YATVDB.fetch_series(134241)
    series.must_be_kind_of YATVDB::Series
    series.name.must_equal 'Justified'
    series.seasons.size.must_equal 4
    series.seasons.first.size.must_equal 13
    series.seasons.last.first.must_be_kind_of YATVDB::Episode
    series.seasons.last.first.name.must_equal "Hole in the Wall"
  end

  it "can fetch complete series data" do
    result = YATVDB.fetch_series(134241)
    result.must_be_kind_of YATVDB::Series
    result.name.must_equal 'Justified'
    result.episodes.must_be_kind_of Array
    result.episodes.first.name.must_equal 'Fire in the Hole'
    result.episodes.last.name.must_equal 'Ghosts'
  end
end
