require_relative '../test_helper'
require 'fileutils'
require 'tmpdir'
require 'yatvdb/fetch'

describe YATVDB::Fetch do
  subject do
    Class.new do
      include YATVDB::Fetch
    end.new
  end

  before do
    @tempdir = Dir.mktmpdir('fetch_test')
    @xml = <<-XML
      <Data>
        <Series>
          <seriesname>Boo</seriesname>
        </Series>
        <Episode>
          <episodename>Foo</episodename>
        </Episode>
        <Episode>
          <episodename>Bar</episodename>
        </Episode>
      </Data>
    XML

    subject.api_key = 'API_KEY'
    subject.cache_path = @tempdir
    FakeWeb.register_uri(
      :get,
      "http://thetvdb.com/api/API_KEY/series/123/en.xml",
      body: @xml
    )
  end

  after do
    FileUtils.remove_entry_secure(@tempdir)
  end

  it "has a default base_uri" do
    subject.base_uri.wont_be_nil
  end

  it "can get a record" do
    subject.fetch('series/123/en.xml').must_equal @xml
    Pathname.new(@tempdir).join("series/123/en.xml").must_be :exist?
  end

  it "can load an entry from the cache" do
    Pathname.new(@tempdir).join("series/999").mkpath
    Pathname.new(@tempdir).join("series/999/en.xml").open('w') do |f|
      f.print "Bang!"
    end
    subject.fetch("series/999/en.xml").must_equal("Bang!")
  end

  it "can fetch a series" do
    result = subject.fetch_series("series/123/en.xml")
    result.must_be_kind_of YATVDB::Series
    result.episodes.first.name.must_equal "Foo"
    result.episodes.last.name.must_equal "Bar"
  end
end
