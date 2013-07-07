require 'rexml/document'
require 'yatvdb/series'
require 'yatvdb/episode'

module YATVDB
  module Parse
    def parse(xml, xpath)
      results = []
      REXML::Document.new(xml).elements.each(xpath) do |node|
        results << case node.name
          when 'Series' then Series.new(node)
          when 'Episode' then Episode.new(node)
          else raise ArgumentError, "Unexpected node type "#{node.name}"
        end
      end
      results
    end
  end
end
