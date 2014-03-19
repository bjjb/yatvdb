require 'open-uri'
require 'pathname'
require 'yaml'
require 'json'
require 'logger'
require 'rexml/document'
require 'yatvdb/version'

# Yet Another TheTVDB.com API client.
module YATVDB
  autoload :Series, "yatvdb/series"
  autoload :Episode, "yatvdb/episode"
  # Cache the result of the block under the path given (usually
  # series/123/all/en.xml, or something similar), or skip the block and read the
  # result if the cached path exists and hasn't expired.
  def cache(path, &block)
    return yield unless cache? # Skip cache
    path = cache_path.join(path)
    if cache_ttl.zero? or (path.exist? and (Time.now - path.mtime) < cache_ttl)
      logger.debug "Cache hit: #{path}"
      return path.read 
    end
    logger.debug "Cache miss: #{path}"
    path.parent.mkpath unless path.parent.exist?
    yield.tap { |s| path.open('w') { |f| f << s.to_s } }
  end

  # Whether or not to use the cache
  def cache?
    cache_path and cache_ttl > 0
  end

  # Various user defined or default configuration variables
  def config
    @config ||= load_config
  end

  # The API key to use for authenticated calls. You can override the configured
  # value in the environment with YATVDB_API_KEY or TVDB_API_KEY.
  def api_key
    @api_key ||= ENV['YATVDB_API_KEY'] ||
      ENV['TVDB_API_KEY'] ||
      config['api_key']
  end

  # Set the API key for all authenticated YATVDB calls.
  def api_key=(api_key)
    @api_key = api_key
  end

  # A location on disk where XML results will be cached. You can override the
  # configured path with YATVDB_CACHE_PATH or TVDB_CACHE_PATH
  def cache_path
    @cache_path ||= Pathname.new(
      ENV['YATVDB_CACHE_PATH'] ||
      ENV['TVDB_CACHE_PATH'] ||
      config['cache_path'] ||
      '~/.yatvdb'
    ).expand_path
  end

  # Set the cache location
  def cache_path=(cache_path)
    @cache_path = Pathname.new(cache_path).expand_path
  end

  # Number of seconds after which caches expire
  def cache_ttl
    @cache_ttl ||= Integer(
      ENV['YATVDB_CACHE_TTL'] ||
      ENV['TVDB_CACHE_TTL'] ||
      config['cache_ttl'] ||
      -1
    )
  end

  # Sets the Time To Live (in seconds) for the cached files
  def cache_ttl=(cache_ttl)
    @cache_ttl = Integer(cache_ttl)
  end

  @@config_paths ||= %w[
    /etc/yatvdb.conf
    /usr/local/etc/yatvdb.conf
    ~/.yatvdb/config
  ]

  # A list of paths from where configurations will be loaded
  def config_paths
    @config_paths ||= @@config_paths
  end

  # Set the paths from which the configuration will be loaded.
  def config_paths=(config_paths)
    @config = nil
    @config_paths = config_paths.map { |p| Pathname.new(p).expand_path }
  end

  # The language to be used (by default) for looking up TVDB data. The default
  # is 'en' (English). You can override this in the environment with YATVDB_LANG
  # or TVDB_LANG (or in a config file).
  def language
    @language ||= ENV['YATVDB_LANG'] || ENV['TVDB_LANG'] || config['language'] || 'en'
  end

  # Set the default languge for TVDB calls.
  def language=(language)
    @langugae = language
  end

  # Loads the configuration from config files.
  def load_config
    data = { 'cache_path' => '~/.yatvdb', 'cache_ttl' => 60 * 60 * 24 }
    config_paths.each do |f|
      path = Pathname.new(f).expand_path
      data.update(YAML.load(path.read) || {}) if path.exist?
    end
    data
  end

  @@base_uri = "http://thetvdb.com/api"

  # The endpoint for TVDB calls
  def base_uri
    @base_uri ||= @@base_uri
  end

  # Set the endpoint for TVDB calls. You probably won't need this.
  def base_uri=(base_uri)
    @base_uri = base_uri
  end

  # Gets stuff from the cache or from TheTVDB. Returns the raw result of the
  # file - it does no checking for the status code, or whatever.
  def fetch(path)
    uri = [base_uri, api_key, path].compact.join("/")
    cache(path) { open(uri).read }
  end

  # Fetch a series from YATVDB. It will load up all the series info, and
  # return a YATVDB::Series object, hopefully complete with episodes. You need
  # to pass in the series ID (which you can get from find_series, if you need
  # it).
  def fetch_series(id, language = language)
    Series.new(fetch("series/#{id}/all/#{language}.xml"))
  end

  # Will query TheTVDB for series that match the string given (and the languge).
  # Returns an Array of Series objects - but they will _not_ contain the full
  # data, so remember to call find_series to get the full series data when you
  # need it.
  def find_series(name, language = language)
    xml = open("#{base_uri}/GetSeries.php?seriesname=#{name}&language=#{language}").read
    results = []
    REXML::Document.new(xml).elements.each('Data/Series') do |node|
      results << Series.new(node)
    end
    results
  end
  alias lookup find_series

  # A standard logger. Level is usually warn, but you can override that with
  # $VERBOSE or $DEBUG or with a config variable. Usually logs to STDOUT, but
  # you can override that with a 'log' config var.
  def logger
    @logger ||= Logger.new(config['log'] || STDOUT).tap do |logger|
      logger.level = if $DEBUG or config['log_level'] == 'debug' || config['debug'] == true
        Logger::DEBUG
      elsif $VERBOSE or config['log_level'] == 'info' || config['verbose'] == true
        Logger::INFO
      else
        Logger::WARN
      end
    end
  end

  # Gets the attributes for the class
  def attributes
    attributes = {}
    self.class.attributes.each do |attr|
      attributes[attr] = send(attr)
    end
    attributes
  end

  # Gets the object as JSON
  def to_json(*args)
    attributes.to_json(*args)
  end

  def self.included(mod)
    mod.send(:extend, ClassMethods)
  end

  module ClassMethods
    def attributes(*args)
      args.each do |arg|
        @attributes ||= []
        @attributes << arg.to_sym
        attr_reader arg
      end
      @attributes
    end
  end

  # You can use YATVDB directly, or you can mix it into a client or something
  extend self
end
