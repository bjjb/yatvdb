require 'rexml/document'
require 'yatvdb/episode'

module YATVDB
  class Series
    include YATVDB

    @@attributes = {
      "actors" => :actors,
      "airs_dayofweek" => :air_dow,
      "airs_time" => :air_time,
      "contentrating" => :content_rating,
      "firstaired" => :first_aired,
      "genre" => :genre,
      "id" => :id,
      "imdb_id" => :imdb_id,
      "language" => :language,
      "network" => :network,
      "networkid" => :network_id,
      "overview" => :overview,
      "rating" => :rating,
      "ratingcount" => :rating_count,
      "runtime" => :runtime,
      "seriesid" => :series_id,
      "seriesname" => :name,
      "status" => :status,
      "added" => :added,
      "addedby" => :added_by,
      "banner" => :banner,
      "fanart" => :fanart,
      "lastupdated" => :last_updated,
      "poster" => :poster,
      "zap2it_id" => :zap2it_id
    }

    attr_accessor *@@attributes.values
    attr_accessor :episodes

    def self.load(source)
      doc = REXML::Document.new(source)
      series = new
      doc.elements.each("Data/Series/*") do |element|
        series.send("#{@@attributes.fetch(element.name.downcase)}=", element.text)
      end
      doc.elements.each("Data/Episode") do |element|
        series.episodes << Episode.load(element)
      end
      series
    end

    def actors
      @actors.split('|').map(&:strip).compact.reject(&:empty?)
    end

    def genres
      @genre.split('|').map(&:strip).compact.reject(&:empty?)
    end

    def banner
      "#{base_uri}/#{@banner}"
    end

    def fanart
      "#{base_uri}/#{@fanart}"
    end

    def poster
      "#{base_uri}/#{@poster}"
    end

  end
end
