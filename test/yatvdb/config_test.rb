require 'test_helper'
require 'yatvdb/config'
require 'tempfile'

describe YATVDB::Config do
  before do
    @dummy = Tempfile.new('config_test')
    @dummy << { 'api_key' => 'TEST_API_KEY' }.to_yaml
    @dummy.rewind
  end

  after do
    @dummy.unlink
  end

  let :configurable do
    Struct.new(:config_paths) { include YATVDB::Config }.new([@dummy.path])
  end

  it "has the right config paths" do
    configurable.config_paths.must_equal [@dummy.path]
  end

  it "has an API key" do
    configurable.config.wont_be_nil
    configurable.api_key.wont_be_nil
    configurable.api_key.must_equal "TEST_API_KEY"
  end

  it "has a cache path" do
    configurable.config.wont_be_nil
    configurable.cache_path.wont_be_nil
    configurable.cache_path.must_equal Pathname.new('~/.yatvdb').expand_path
  end
end
