require 'open-uri'
require 'nokogiri'
require 'builder/xmlmarkup'

module Vkcom
  class Site
    def initialize(url)
      @url = url
    end

    def tracks
      @tracks ||= find_tracks
    end

    def to_xml
      xml = Builder::XmlMarkup.new
      xml.instruct! :xml, :version => '1.0'
      xml.rss :version => "2.0", 'xmlns:itunes' => 'http://www.itunes.com/dtds/podcast-1.0.dtd' do
        xml.channel do
          xml.title       "vk.com podcast for %s" % @url
          xml.description "vk.com podcast for %s" % @url
          xml.link        @url

          tracks.each do |track|
            xml.item do
              xml.title track.title
              xml.description track.title
              xml.link track.media_url
              xml.guid track.media_url
              xml.enclosure :url => track.media_url
              xml.author track.artist
              xml.itunes :author, track.artist
            end
          end
        end
      end
    end

    private

    def find_tracks
      doc.xpath('//input[@type="hidden" and contains(@value, "mp3")]').map do |el|
        id                  = el['id'].sub(/audio_info\-?/, '')
        media_url, duration = el['value'].split(',')
        title_elem          = doc.xpath('//span[contains(@id, "%s")]' % id)[0]
        title               = title_elem.text
        artist              = title_elem.previous.previous.text

        Track.new(
          :media_url => media_url,
          :duration  => duration,
          :title     => title,
          :artist    => artist
          )
      end
    end

    def doc
      @doc ||= Nokogiri::HTML(open(@url, {
            "User-Agent" => 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:2.0.1) Gecko/20100101 Firefox/4.0.1',
            "Accept"     => 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8'
          })
        )
    end
  end
end

