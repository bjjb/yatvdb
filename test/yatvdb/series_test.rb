require_relative "../test_helper"
require 'yatvdb/series'

describe YATVDB::Series do
  describe "loading from an xml search result" do
    before do
      @series = YATVDB::Series.load(fixture('justified.xml').read)
      @series.load!
    end

    it "has the right series_id" do
      @series.id.must_equal 134241
    end

    it "loads from the right cache" do
      @series.cache.must_equal Pathname.new(__FILE__).join("../../fixtures/series/134241/all/en.xml").expand_path
    end

    it "has the right name" do
      @series.name.must_equal "Justified"
    end

    it "has the right actors" do
      @series.actors.must_include "Timothy Olyphant"
    end

    it "has the right genre" do
      @series.genres.must_include "Drama"
    end

    it "has episodes" do
      @series.episodes.must_be_kind_of Array
      @series.episodes.first.wont_be_nil
      @series.episodes.first.must_be_kind_of YATVDB::Episode
    end
  end
end
