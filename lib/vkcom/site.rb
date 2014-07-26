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
              xml.guid track.guid
              xml.enclosure :url => track.media_url
              xml.author track.artist
              xml.itunes :author, track.artist
              xml.itunes :summary, track.title
              xml.pubDate track.pub_date.utc.rfc822
            end
          end
        end
      end
    end

    private

    def find_tracks
      doc.xpath('//div[@class="post_table"]').inject([]) do |tracks, post_table|
        timestamp = post_table.xpath('//span[@class="rel_date" or @class="rel_date rel_date_needs_update"]')[0]['time'].to_i
        time = Time.at(timestamp)

        post_table.xpath('.//input[@type="hidden" and contains(@value, "mp3")]').each do |el|
          id                  = el['id'].sub(/audio_info\-?/, '')
          media_url, duration = el['value'].split(',')
          title_elem          = doc.xpath('//span[contains(@id, "%s")]' % id)[0]
          title               = title_elem.text
          artist              = title_elem.previous.previous.text

          tracks << Track.new(
            :media_url => media_url,
            :duration  => duration,
            :title     => title,
            :artist    => artist,
            :pub_date  => time.utc.rfc822
          )
        end

        tracks
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

