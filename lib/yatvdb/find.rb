require 'rexml/document'
require 'yatvdb/fetch'
require 'yatvdb/series'

module YATVDB
  module Find
    include Fetch

    # Search for a series by name. Returns only basic info for a series - use the
    # series' series_id's to fetch the full data, if you need it.
    #
    #     YATVDB.find_series('Justified')
    #     # => [<YATVDB::Series @name='Justified' @series_id=134241 ...>]
    def find_series(name, language = language)
      series = []
      name = URI.escape(name)
      xml = open("#{base_uri}/GetSeries.php?seriesname=#{name}&language=#{language}").read
      REXML::Document.new(xml).elements.each('/Data/Series') do |node|
        series << Series.new(node)
      end
      series
    end
  end
end
