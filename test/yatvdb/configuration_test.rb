require 'test_helper'
require 'yatvdb/configuration'
require 'tempfile'
require 'yaml'

describe YATVDB::Configuration do
  before do
    @tmpfile = Tempfile.new('config')
    @tmpfile.write({'foo' => { 'bar' => 'Baz' } }.to_yaml)
  end

  after do
    @tmpfile.close
    @tmpfile.unlink
  end

  subject do
    Struct.new(:config_paths) do
      include YATVDB::Configuration
    end.new([Pathname.new(@tmpfile.path)])
  end

  it "loads up the config properly" do
    @tmpfile.read
    subject.config['foo']['bar'].must_equal 'Baz'
  end
end
