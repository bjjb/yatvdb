require_relative '../test_helper'

describe YATVDB::Episode do
  let :episode do
    YATVDB::Episode.new(File.read(File.expand_path("../../fixtures/episodes/1529491/en.xml", __FILE__)))
  end

  it "has an id" do
    episode.id.must_equal 1529491
  end
end
