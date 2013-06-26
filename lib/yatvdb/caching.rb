require 'yatvdb/configuration'
require 'tmpdir'

module YATVDB #:nodoc:
  # Contains the logic for caching XML files
  module Caching

    def cached?(language = self.language)
      cache.exist?
    end

    def cache(language = self.language)
      cache_path.join("#{cache_part}/#{id}/all/#{language}.xml")
    end

    def cache_part
      self.class.name.split('::').last.downcase
    end

    def cache_path
      return @cache_path if defined?(@cache_path)
      cache_path = ENV['YATVDB_PATH']
      cache_path ||= ENV['TVDB_PATH']
      cache_path ||= config['cache'] if respond_to?(:config)
      cache_path ||= Dir.mktmpdir
      @cache_path = Pathname.new(cache_path)
    end
  end
end
