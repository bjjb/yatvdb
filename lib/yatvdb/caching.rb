require 'yatvdb/configuration'
require 'tmpdir'

module YATVDB #:nodoc:
  # Contains the logic for caching XML files
  module Caching

    def cached?(language = self.language)
      cache.exist?
    end

    def cache(language = self.language)
      cache_dir.join("#{cache_part}/#{id}/all/#{language}.xml")
    end

    def cache_part
      self.class.name.split('::').last.downcase
    end

    def cache_dir
      return @cache_dir if defined?(@cache_dir)
      cache_dir = ENV['YATVDB_CACHE_DIR']
      cache_dir ||= ENV['TVDB_CACHE_DIR']
      cache_dir ||= config['cache'] if respond_to?(:config)
      cache_dir ||= Dir.mktmpdir
      @cache_dir = cache_dir
    end

    def cache_path
      @cache_path ||= Pathname.new(cache_dir)
    end

    def cache_dir=(dir)
      @cache_dir = dir
    end

    def cache_ttl
      @cache_ttl ||= 60 * 60 * 24
    end

    def cache_expired?(cache)
      (Time.now - cache.mtime) > cache_ttl
    end

    def get(path)
      cache = cache_path.join(path)
      return cache.read if cache.exist? and !cache_expired?(cache)
      result = super
      cache.parent.mkpath
      cache.open('w') { |f| f.print(result) }
      result
    end
  end
end
