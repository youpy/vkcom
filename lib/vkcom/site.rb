require 'open-uri'
require 'nokogiri'
require 'chronic'

module Vkcom
  class Site
    def initialize(url)
      @url = url
    end

    def tracks
      @tracks ||= find_tracks
    end

    private

    def find_tracks
      doc.xpath('//div[@class="post_table"]').inject([]) do |tracks, post_table|
        time_text = post_table.xpath('.//span[@class="rel_date" or @class="rel_date rel_date_needs_update"]')[0].text
        time = Chronic.parse(time_text, :now => Time.now.utc)

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
            :pub_date  => time
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

