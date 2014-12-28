require 'builder/xmlmarkup'

module Vkcom
  module Renderer
    class XML
      def initialize(site)
        @site = site
      end

      def render
        xml = Builder::XmlMarkup.new
        xml.instruct! :xml, :version => '1.0'
        xml.rss :version => "2.0", 'xmlns:itunes' => 'http://www.itunes.com/dtds/podcast-1.0.dtd' do
          xml.channel do
            xml.title       "vk.com podcast for %s" % @url
            xml.description "vk.com podcast for %s" % @url
            xml.link        @url

            @site.tracks.each do |track|
              xml.item do
                xml.title track.title
                xml.description track.title
                xml.link track.media_url
                xml.guid track.guid
                xml.enclosure :url => track.media_url
                xml.author track.artist
                xml.itunes :author, track.artist
                xml.itunes :summary, track.title
                xml.itunes :duration, duration_to_str(track.duration)
                xml.pubDate track.pub_date.utc.rfc822
              end
            end
          end
        end
      end

      private

      def duration_to_str(duration)
        [60, 60, 24].inject([duration, []]) do |(dur, digits), n|
          digit = (dur % n).to_s
          digits << (digit.size < 2 ? '0' + digit : digit)
          [dur / n, digits]
        end[1].reverse.join(':')
      end
    end
  end
end
