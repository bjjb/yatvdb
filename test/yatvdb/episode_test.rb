require_relative '../test_helper'

describe YATVDB::Episode do
  describe "full episode data" do
    let :episode do
      YATVDB::Episode.new(File.read(File.expand_path("../../fixtures/episodes/1529491/en.xml", __FILE__)))
    end

    it "has an id" do
      episode.id.must_equal 1529491
    end

    it "loads the guest stars" do
      episode.guest_stars.must_include 'Joelle Carter'
      episode.guest_stars.must_include 'Walton Goggins'
    end

    it "loads the name" do
      episode.name.must_equal "Fire in the Hole"
    end

    it "loads the first_aired date" do
      episode.first_aired.must_equal Date.new(2010, 03, 16)
    end

    it "loads the writers" do
      episode.writers.must_be_kind_of Array
      episode.writers.must_include 'Graham Yost'
    end

    it "loads the rating as a float" do
      episode.rating.must_equal 7.5
    end

    it "loads the DVD info" do
      episode.dvd_disc_id.must_be_nil
      episode.dvd_season.must_equal 1
      episode.dvd_episode_number.must_equal 1.0
    end

    it "loads the last_updated time" do
      episode.last_updated.must_equal Time.at(1367386515)
    end
  end
end
