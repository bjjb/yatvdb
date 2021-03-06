require "test_helper"
require 'tmpdir'
require 'yatvdb/series'

describe YATVDB::Series do
  describe "partial series data" do
    let :series do
      YATVDB::Series.new('<Data><Series><id>134241</id><language>en</language></Series></Data>')
    end

    it "is a series" do
      series.must_be_kind_of YATVDB::Series
      series.id.must_equal 134241
    end

    it "starts with no @episodes" do
      series.instance_variable_get('@episodes').must_be_nil
    end
  end

  describe "full series data" do
    let :series do
      YATVDB::Series.new(File.read(File.expand_path("../../fixtures/series/134241/all/en.xml", __FILE__)))
    end

    it "loads the right id" do
      series.id.must_equal 134241
    end

    it "loads the right language" do
      series.language.must_equal 'en'
    end

    it "loads the actors" do
      series.actors.must_include 'Timothy Olyphant'
      series.actors.must_include 'Nick Searcy'
      series.actors.must_include 'Erica N. Tazel'
    end

    it "loads the genres" do
      series.genres.must_include 'Drama'
    end

    it "loads the series name" do
      series.name.must_equal "Justified"
    end

    it "loads the series overview" do
      series.overview.must_include "Deputy U.S. Marshal Raylan Givens"
    end

    it "loads the first aired date" do
      series.first_aired.must_equal Date.new(2010, 03, 16)
    end

    it "loads the network" do
      series.network.must_equal 'FX'
    end

    it "loads the IMDB ID" do
      series.imdb_id.must_equal "tt1489428"
    end

    it "loads all the episodes" do
      series.episodes.size.must_equal 52
    end

    it "has the seasons in the right order" do
      series.seasons.size.must_equal 4
    end
  end

  describe "attributes" do
    it "contains all the necessary attributes" do
      YATVDB::Series.instance_variable_get('@attributes').must_include :id
      YATVDB::Series.attributes.must_include :id
      YATVDB::Series.attributes.must_include :banner
    end

    it "can give us all attributes" do
      series = YATVDB::Series.new('<id>123</id>')
      series.must_respond_to :attributes
      series.attributes.must_be_kind_of Hash
      series.attributes[:id].must_equal 123
    end
  end

  describe "to_json" do
    it "contains all attributes" do
      series = YATVDB::Series.new('<id>123</id>')
      json = series.to_json
      json.must_be_kind_of String
      hash = JSON.parse(json)
      hash['id'].must_equal 123
    end
  end
end
