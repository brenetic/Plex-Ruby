module Plex
  class Artist

    ATTRIBUTES = %w(ratingKey guid type title summary index thumb addedAt updatedAt)

    attr_reader :section, :key, :attribute_hash

    # @param [Section] section this artist belongs to
    # @param [String] key to use to later grab the Artist
    def initialize(section, key)
      @section = section
      @key = key
      @attribute_hash = {}

      directory.attributes.each do |method, val|
        @attribute_hash[Plex.underscore(method)] = val.value
        define_singleton_method(Plex.underscore(method).to_sym) do
          val.value
        end
      end

      @attribute_hash.merge({'key' => @key})
    end

    def location
      directory.children.find('Location').select do |element|
        return element['path'] if element.key?('path')
      end
    end

    def inspect
      "#<Plex::Artist: key=\"#{key}\" title=\"#{title}\">"
    end

    private

    def url
      section.url
    end

    def base_doc
      Nokogiri::XML( Plex.open(url+key) )
    end

    def children_base
      Nokogiri::XML( Plex.open(url+key+'/children') )
    end

    def xml_doc
      @xml_doc ||= base_doc
    end

    def children
      @children ||= children_base
    end

    def directory
      @directory ||= xml_doc.search('Directory').first
    end
  end
end
