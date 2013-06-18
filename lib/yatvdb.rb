require "yatvdb/version"
require "pathname"
require "tmpdir"
require "yaml"
require 'open-uri'
require 'nokogiri'
require 'yatvdb/series'

# Yet Another TheTVDB.com API client.
module YATVDB
  # Gets the configured API key from the environment (YATVDB_API_KEY.
  # TVDB_API_KEY, or the configuration's tvdb.api_key).
  def api_key
    @@api_key ||= ENV['YATVDB_API_KEY'] ||
      ENV['TVDB_API_KEY'] ||
      config['tvdb']['api_key'] ||
      raise("No TVDB API key! Specify YATVDB_API_KEY in the environment.")
  end

  # Sets the API key for subsequent calls
  def api_key=(api_key)
    @@api_key = api_key
  end

  # The base URI for API calls
  def base_uri
    config['tvdb']['uri'] || "http://thetvdb.com/api"
  end

  # Where to store XML files from TVDB
  def cache
    @@cache ||= Pathname.new(ENV['YATVDB_PATH'] ||
      ENV['TVDB_PATH'] ||
      config['tvdb']['cache'] ||
      Dir.mktmpdir)
  end

  def cache=(path)
    @@cache = Pathname.new(path).expand_path.tap(&:mkpath)
  end

  # Gets the language used by default for calls
  def language
    @@language ||= 'en'
  end

  # Sets the language used by default
  def language=(language)
    @@language = language
  end

  # Configuration.
  def config
    @@config ||= load_config
  end

  # Load the user or system config file
  def load_config
    config = {
      'tvdb' => {
        'cache' => '~/.yatvdb'
      }
    }
    [
      '/etc/yatvdb.conf',
      '/usr/local/etc/yatvdb.conf',
      '~/.yatvdb/config'
    ].each do |f|
      path = Pathname.new(f).expand_path
      config.update(YAML.load(path.read)) if path.exist?
    end
    config
  end

  # Search for a series by name. Returns only basic info for a series - use the
  # series' series_id's to fetch the full data, if you need it.
  #
  #     YATVDB.get_series('Justified')
  #     # => [<YATVDB::Series @name='Justified' @series_id=134241 ...>]
  #     series.first.load!
  #     # => <YATVDB::Series @name='Justified' ...full series data...>
  #     series.number_of_seasons # => 4
  #     series.episodes
  #     # => [<YATVDB::Episode @number=1 ...>, ...]
  def get_series(name, language = language)
    name = URI.escape(name)
    result = open("#{base_uri}/GetSeries.php?seriesname=#{name}&language=#{language}")
    Nokogiri::XML(result.read).xpath('/Data/Series').map do |node|
      Series.new(node)
    end
  end

  extend self
end
