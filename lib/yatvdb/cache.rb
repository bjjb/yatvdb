require 'pathname'
require 'yatvdb/config'

module YATVDB
  # A simple module for caching TVDB results
  module Caching

    # Reads text from a cache, if it exists and is not stale. Otherwise runs the
    # block, and writes the result to the cache.
    #
    #    cache('foo/bar') { 123 } #=> writes 123
    #    cache('foo/bar') { 123 } #=> reads 123 from the cache
    #
    # If the cache is older than `ttl` seconds, it's considered stale.
    def cache(path, &block)
      path = self.path.join(path)
      return path.read if valid?(path)
      path.parent.mkpath unless path.parent.exist?
      yield.tap { |result| path.open('w') { |f| f << result.to_s } }
    end

  private

    def valid?(path)
      path.exist? and !stale?(path)
    end

    def stale?(path)
      Time.now - path.mtime > ttl
    end

    def dir
      @dir ||= config.cache.dir
    end

    def path
      @path ||= Pathname.new(dir).expand_path
    end

    def dir=(dir)
      @path = nil
      @dir = dir
    end

    def ttl
      @ttl ||= config.cache.ttl
    end

    def ttl=(ttl)
      @ttl = ttl
    end
  end
end
