require 'open-uri'

module YATVDB
  module Fetch
    include Config
    include Cache

    def get(path)
      cache path do
        open("#{base_uri}/#{api_key}/#{path}").read
      end
    end
  end
end
