require 'date'
require 'rexml/document'
require 'yatvdb/episode'

module YATVDB
  class Series
    @@attr_map = {
      airs_dayofweek: :air_day,
      airs_time: :air_time,
      contentrating: :content_rating,
      firstaired: :first_aired,
      genre: :genres,
      networkid: :network_id,
      ratingcount: :rating_count,
      seriesid: :series_id,
      seriesname: :name,
      addedby: :added_by,
      last_updated: :lastupdated
    }

    attr_reader :id, :actors, :genres, :name, :overview, :first_aired, :network,
      :imdb_id, :zap2it_id, :series_id, :language, :air_day, :air_time,
      :content_rating, :network_id, :rating, :rating_count, :runtime, :status,
      :added, :added_by, :banner, :fanart, :last_updated, :poster

    %i[banner poster fanart].each do |m|
      define_method m do
        ivar = :"@#{m}"
        "#{base_uri}/#{instance_variable_get(ivar)}" if instance_variable_defined?(ivar)
      end
    end

    %i[first_aired].each do |m|
      define_method m do
        ivar = :"@#{m}"
        DateTime.parse(instance_variable_get(ivar)) if instance_variable_defined?(ivar)
      end
    end

    %i[id].each do |m|
      define_method m do
        ivar = :"@#{m}"
        Integer(instance_variable_get(ivar)) if instance_variable_defined?(ivar)
      end
    end

    %i[actors genres].each do |m|
      define_method m do
        ivar = :"@#{m}"
        instance_variable_get(ivar).split('|').map(&:strip).compact if instance_variable_defined?(ivar)
      end
    end

    def episodes
      @episodes
    end

    def seasons
      return @seasons if @seasons
      seasons = {}
      @episodes.each do |episode|
        seasons[episode.season_number] ||= []
        seasons[episode.season_number] << episode
      end
      @seasons = seasons.keys.sort.map do |n|
        seasons[n].sort_by(&:number)
      end
    end

    def initialize(xml)
      load!(xml)
    end

    def self.load(xml)
      new.load!(xml)
    end

    def load!(xml)
      xml = xml.read if xml.respond_to?(:read)
      xml = REXML::Document.new(xml) if xml.is_a?(String)
      (xml.elements['Data/Series'] || xml.elements['Series'] || xml).elements.each do |element|
        next unless element.text
        next if element.text.empty?
        ivar = element.name.downcase.to_sym
        ivar = @@attr_map[ivar] if @@attr_map.key?(ivar)
        ivar = :"@#{ivar}"
        instance_variable_set(ivar, element.text.strip)
      end
      @episodes = []
      xml.elements.each('Data/Episode') do |element|
        @episodes << Episode.new(element)
      end
    end
  end
end
