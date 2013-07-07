require 'open-uri'

module YATVDB
  module Fetch
    require 'yatvdb/cache'
    include Cache

    @@base_uri = "http://thetvdb.com/api"

    def base_uri
      @base_uri ||= @@base_uri
    end

    def base_uri=(base_uri)
      @base_uri = base_uri
    end

    # Gets stuff from the cache or from TheTVDB.
    def get(path)
      cache(path) do
        open("#{base_uri}/#{api_key}/#{path}").read
      end
    end
  end
end
