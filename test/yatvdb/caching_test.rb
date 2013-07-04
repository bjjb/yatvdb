require 'test_helper'
require 'yatvdb/caching'
require 'tmpdir'
require 'fileutils'

describe YATVDB::Caching do
  before do
    @tmpdir = Dir.mktmpdir
  end

  after do
    FileUtils.rm_rf @tmpdir
  end

  subject do
    Struct.new(:config, :language, :id) do
      include YATVDB::Caching
      def self.name() 'Dummy' end
    end.new({'cache' => Pathname.new(@tmpdir)}, 'fr', 123)
  end

  it "knows where to cache things" do
    subject.cache_dir.to_s.must_equal @tmpdir
  end

  it "knows where to cache itself" do
    subject.cache.to_s.must_equal "#{@tmpdir}/dummy/123/all/fr.xml"
  end

  it "knows when its cached" do
    subject.wont_be :cached?
    FileUtils.mkpath("#{@tmpdir}/dummy/123/all")
    File.open("#{@tmpdir}/dummy/123/all/fr.xml", 'w') do |f|
      f.puts "Hello"
    end
    subject.must_be :cached?
  end
end
