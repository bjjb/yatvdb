require 'test_helper'
require 'yatvdb/config'
require 'tmpfile'

describe YATVDB::Config do
  before do
    @dummy = Tempfile.new('dummy')
    @dummy.puts { "" => "", "" => { "" => "", "" => "" } }.to_yaml
    @dummy.clode
  end

  after do
    @dummy.unlink
  end

  let :configurable do
    Class.new { include YATVDB::Config }.config.must_be_kind_of YATVDB::Configuration
  end

  describe "a configurable object" do
    it "has a config" do
      configurable.config.must_be_kind_of YATVDB::Configuration
    end
  end

  describe "a config" do
    let :config do
      configurable.config
    end

    it "has an API key" do
      config.api_key.must_equal "TEST_API_KEY"
    end

    it "has a cache" do
      config.cache_path.must_be_kind_of Pathname.new('/test/cache/path')
      config.cache_ttl.must_equal 99
    end
  end
end
