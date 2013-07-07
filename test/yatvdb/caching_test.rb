require 'test_helper'
require 'yatvdb/cache'
require 'tmpdir'
require 'fileutils'

describe YATVDB::Cache do
  before { @tmpdir = Dir.mktmpdir }
  after { FileUtils.rm_rf @tmpdir }

  subject do
    cache = Class.new do
      include YATVDB::Cache
    end.new
    cache.cache_path = @tmpdir
    cache.cache_ttl = "1000"
    cache
  end

  it "will has a configurable cache_path" do
    subject.must_respond_to :"cache_path="
    subject.must_respond_to :"cache_path"
    subject.cache_path.must_equal Pathname.new(@tmpdir)
  end

  it "will has a configurable cache_ttl" do
    subject.must_respond_to :"cache_ttl="
    subject.must_respond_to :"cache_ttl"
    subject.cache_ttl.must_equal 1000
  end

  it "can cache things" do
    subject.must_respond_to :cache
  end

  it "caches things" do
    subject.cache('a/b') { "Hello" }.must_equal "Hello"
    subject.cache_path.join('a/b').must_be :exist?
    subject.cache_path.join('a/b').read.must_equal "Hello"
    subject.cache('a/b') { "Goodbye" }.must_equal "Hello"
  end
end
