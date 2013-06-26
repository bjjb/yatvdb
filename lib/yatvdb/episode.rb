module YATVDB
  class Episode
    @@attr_map = {
      dvd_discid: :dvd_disc_id,
      dvd_episodenumber: :dvd_episode_number,
      director: :directors,
      episodename: :name,
      episodenumber: :number,
      gueststars: :guest_stars,
      productioncode: :production_code,
      writer: :writers,
      airsafter_season: :airs_after_season,
      airsbefore_episode: :airs_before_episode,
      airsbefore_season: :airs_before_season,
      filename: :image,
      lastupdated: :last_updated,
      seasonid: :season_id,
      seriesid: :series_id,
      seasonnumber: :season_number
    }

    attr_reader :id, :dvd_chapter, :dvd_disc_id, :dvd_episode_number,
      :dvd_season, :directors, :name, :number, :first_aired, :guest_stars,
      :imdb_id, :language, :overview, :production_code, :rating, :season,
      :writers, :absolute_number, :image, :last_updated, :season_id, :series_id,
      :season_number

    %i[id].each do |m|
      define_method m do
        ivar = :"@#{m}"
        Integer(instance_variable_get(ivar)) if instance_variable_defined?(ivar)
      end
    end

    def initialize(doc)
      load!(doc)
    end

    def load!(xml)
      xml = xml.read if xml.respond_to?(:read)
      xml = REXML::Document.new(xml) if xml.is_a?(String)
      (xml.elements['Data/Episode'] || xml.elements['Episode'] || xml).elements.each do |element|
        next unless element.text
        next if element.text.empty?
        ivar = element.name.downcase.to_sym
        ivar = @@attr_map[ivar] if @@attr_map.key?(ivar)
        ivar = :"@#{ivar}"
        instance_variable_set(ivar, element.text.strip)
      end
    end
  end
end
