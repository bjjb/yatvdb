require 'yaml'
require 'open-uri'
require 'rexml/document'
require 'yatvdb/version'
require 'yatvdb/series'
require 'yatvdb/episode'
require 'yatvdb/configuration'
require 'yatvdb/caching'

# Yet Another TheTVDB.com API client.
module YATVDB

  def self.included(mod)
    mod.send(:extend, ClassMethods)
  end

  def merge!(another)
    @@attributes.values.each do |attr|
      instance_variable_set(:"@#{attr}", another.instance_variable_get(:"@#{attr}"))
    end
    self
  end

  def merge(another)
    new.merge!(self).merge!(another)
  end

  def id
    Integer(@id)
  end

  def language
    @language
  end

  # Load data from cache or the web
  def load!
    raise "Can't fetch series without an id" unless id
    cache.open('w') do |f|
      f.write open(remote).read
    end unless cached?
    return merge!(self.class.load(cache.read))
  end

  def remote
    remote_path.join("#{self.class.name.split('::').last.downcase}/#{id}/all/#{language}.xml")
  end

  # Gets the configured API key from the environment (YATVDB_API_KEY.
  # TVDB_API_KEY, or the configuration's tvdb.api_key).
  def api_key
    @@api_key ||= ENV['YATVDB_API_KEY'] ||
      ENV['TVDB_API_KEY'] ||
      config['api_key'] ||
      raise("No TVDB API key! Specify YATVDB_API_KEY in the environment.")
  end

  # Sets the API key for subsequent calls
  def api_key=(api_key)
    @@api_key = api_key
  end

  # The base URI for API calls
  def base_uri
    config['yatvdb']['uri'] || "http://thetvdb.com/api"
  end

  def cache_dir=(path)
    @@cache_dir = Pathname.new(path).expand_path.tap(&:mkpath)
  end

  # Gets the language used by default for calls
  def default_language
    @@default_language ||= 'en'
  end

  # Sets the language used by default
  def default_language=(language)
    @@default_language = language
  end

  # Search for a series by name. Returns only basic info for a series - use the
  # series' series_id's to fetch the full data, if you need it.
  #
  #     YATVDB.find_series('Justified')
  #     # => [<YATVDB::Series @name='Justified' @series_id=134241 ...>]
  #     series.first.load!
  #     # => <YATVDB::Series @name='Justified' ...full series data...>
  #     series.number_of_seasons # => 4
  #     series.episodes
  #     # => [<YATVDB::Episode @number=1 ...>, ...]
  def find_series(name, language = default_language)
    name = URI.escape(name)
    xml = open("#{base_uri}/GetSeries.php?seriesname=#{name}&language=#{language}").read
    series = []
    REXML::Document.new(xml).elements.each('/Data/Series') do |node|
      series << Series.new(node)
    end
    series
  end

  def get(path)
    open("#{base_uri}/#{api_key}/#{path}").read
  end

  extend self
  extend Configuration
  extend Caching
end
