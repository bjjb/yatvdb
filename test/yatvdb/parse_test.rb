require_relative '../test_helper'
require 'yatvdb/parse'

describe YATVDB::Parse do
  subject do
    Class.new do
      include YATVDB::Parse
    end.new
  end

  it "builds a series from a Series" do
    x = subject.parse('<Data><Series></Series><Series></Series></Data>', 'Data/Series')
    x.size.must_equal 2
    x.first.must_be_kind_of YATVDB::Series
    x.last.must_be_kind_of YATVDB::Series
  end

  it "builds episodes from Episodes" do
    x = subject.parse('<Data><Episode></Episode><Episode></Episode></Data>', 'Data/Episode')
    x.size.must_equal 2
    x.first.must_be_kind_of YATVDB::Episode
    x.last.must_be_kind_of YATVDB::Episode
  end
end
