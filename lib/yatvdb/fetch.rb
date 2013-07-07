require 'open-uri'

module YATVDB
  module Fetch
    require 'yatvdb/cache'
    include Cache

    require 'yatvdb/parse'
    include Parse

    @@base_uri = "http://thetvdb.com/api"

    def base_uri
      @base_uri ||= @@base_uri
    end

    def base_uri=(base_uri)
      @base_uri = base_uri
    end

    # Gets stuff from the cache or from TheTVDB.
    def fetch(path)
      cache(path) do
        open("#{base_uri}/#{api_key}/#{path}").read
      end
    end

    def fetch_series(path)
      data = fetch(path)
      series = parse(data, 'Data/Series')
      raise "No series found" unless series.size == 1
      series = series.first
      raise "Uh oh... #{series.first} is not a Series" unless series.is_a? Series
      parse(data, 'Data/Episode').each do |episode|
        series.episodes << episode
      end
      series
    end
  end
end
