require 'test_helper'

class TestArtist < Plex::Artist
  def initialize(parent, key)
    @xml_doc = FakeNode.new(FAKE_ARTIST_NODE_HASH)
    super(parent, key)
  end
end


describe Plex::Show do
  before do
    @section = FakeParent.new
    @artist = TestArtist.new(@section, '/library/metadata/10')
  end

  Plex::Show::ATTRIBUTES.map{|m| Plex.underscore(m)}.each { |method|
    it "should properly respond to ##{method}" do
      @show.send(method.to_sym).must_equal FAKE_SHOW_NODE_HASH[:Directory].attr(method)
    end
  }

  it "should remember its parent (section)" do
    @artist.section.must_equal @section
  end
end
