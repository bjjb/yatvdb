require 'pathname'
require 'yaml'

module YATVDB
  module Config
    def config
      @config ||= Configuration.new
    end
  end

  class Configuration

    def initialize(paths = self.class.paths)
      @paths = paths
    end

    def config
      @config ||= load_config
    end

    def api_key
      ENV['YATVDB_API_KEY'] || ENV['TVDB_API_KEY'] || config['api_key']
    end

    def cache_path
      path = ENV['YATVDB_CACHE_PATH'] || ENV['TVDB_CACHE_PATH'] || cache['path']
      Pathname.new(path) if path
    end

    def cache_ttl
      Integer(ENV['YATVDB_CACHE_TTL'] || ENV['TVDB_CACHE_TTL'] || cache['ttl'] || 0)
    end

    def cache
      config['cache'] || {}
    end
    
    # Loads a config, if it can find one, from the config_paths
    def load_config(paths = paths)
      data = { 'cache' => { 'path' => '~/.yatvdb', 'ttl' => (60 * 60 * 24) } }
      paths.each do |f|
        path = Pathname.new(f).expand_path
        data.update(YAML.load(path.read) || {}) if path.exist?
      end
      data
    end

    def self.paths
      @paths ||= %w[
        /etc/yatvdb.conf
        /usr/local/etc/yatvdb.conf
        ~/.yatvdb/config
      ]
    end
  end
end
