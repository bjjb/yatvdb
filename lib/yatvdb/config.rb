require 'pathname'
require 'yaml'

module YATVDB
  module Config
    def config
      @config ||= load_config
    end

    def api_key
      @api_key ||= ENV['YATVDB_API_KEY'] ||
        ENV['TVDB_API_KEY'] ||
        config['api_key']
    end

    def api_key=(api_key)
      @api_key = api_key
    end

    def cache_path
      @cache_path ||= Pathname.new(
        ENV['YATVDB_CACHE_PATH'] ||
        ENV['TVDB_CACHE_PATH'] ||
        config['cache_path'] ||
        '~/.yatvdb'
      ).expand_path
    end

    def cache_path=(cache_path)
      @cache_path = Pathname.new(cache_path).expand_path
    end

    def cache_ttl
      @cache_ttl ||= Integer(
        ENV['YATVDB_CACHE_TTL'] ||
        ENV['TVDB_CACHE_TTL'] ||
        config['cache_ttl'] ||
        -1
      )
    end

    def cache_ttl=(cache_ttl)
      @cache_ttl = Integer(cache_ttl)
    end

    def config_paths
      @config_paths ||= %w[
        /etc/yatvdb.conf
        /usr/local/etc/yatvdb.conf
        ~/.yatvdb/config
      ]
    end

    def config_paths=(config_paths)
      @config_paths = config_paths.map { |p| Pathname.new(p).expand_path }
    end

    def language
      @language ||= ENV['YATVDB_LANG'] || ENV['TVDB_LANG'] || config['language'] || 'en'
    end

    def language=(language)
      @langugae = language
    end

    def load_config
      data = { 'cache_path' => '~/.yatvdb', 'cache_ttl' => 60 * 60 * 24 }
      config_paths.each do |f|
        path = Pathname.new(f).expand_path
        data.update(YAML.load(path.read) || {}) if path.exist?
      end
      data
    end
  end
end
