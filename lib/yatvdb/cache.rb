require 'pathname'
require 'yatvdb/config'

module YATVDB
  # A simple module for caching TVDB results. Before using it, 
  module Cache
    include Config

    def cache(path, &block)
      return yield unless cache_path
      path = cache_path.join(path)
      return path.read if cache_ttl.zero? or (path.exist? and (Time.now - path.mtime) < cache_ttl)
      path.parent.mkpath unless path.parent.exist?
      yield.tap { |s| path.open('w') { |f| f << s.to_s } }
    end
  end
end
