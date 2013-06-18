module YATVDB
  class Series
    include YATVDB

    @@attributes = {
      actors: "actors",
      air_dow: "airs_dayofweek",
      air_time: "airs_time",
      content_rating: "contentrating",
      first_aired: "firstaired",
      genre: "genre",
      id: "id",
      imdb_id: "imdb_id",
      language: "language",
      network: "network",
      network_id: "networkid",
      overview: "overview",
      rating: "rating",
      rating_count: "ratingcount",
      runtime: "runtime",
      series_id: "seriesid",
      name: "seriesname",
      status: "status",
      added: "added",
      added_by: "addedby",
      banner: "banner",
      fanart: "fanart",
      last_updated: "lastupdated",
      poster: "poster",
      zap2it_id: "zap2it_id"
    }

    attr_accessor *@@attributes.keys

    def initialize(xml)
      load(xml)
    end

    def load(xml)
      xml.elements.each do |element|
        ivar = @@attributes.invert.fetch(element.name.downcase)
        value = element.text.strip
        send("#{ivar}=", value)
      end
    end

    def actors
      @actors.split('|').map(&:strip)
    end

    def banner
      "#{base_uri}/®{@banner}"
    end

    def fanart
      "#{base_uri}/®{@fanart}"
    end

    def poster
      "#{base_uri}/®{@poster}"
    end

    # Load the series data from cache or the web
    def fetch!
      raise "Can't fetch series without a series_id" unless series_id
      cache.open('w') do |f|
        f.write open(remote).read
      end unless cached?
      return load(Nokogiri::XML(cache.read).xpath('/Data/Series').first)
    end

    def cached?
      cache.exist?
    end
    
    def cache
      super.join("series/#{series_id}/all/#{language}.xml")
    end

    def remote
      super.join("series/#{series_id}/all/#{language}.xml")
    end
  end
end
