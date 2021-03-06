require 'virtus'
require 'digest/md5'

module Vkcom
  class Track
    include Virtus.model

    attribute :title,     String
    attribute :artist,    String
    attribute :media_url, String
    attribute :duration,  Integer
    attribute :pub_date,  Time

    def guid
      Digest::MD5.hexdigest([title, artist, duration].join('_'))
    end
  end
end
