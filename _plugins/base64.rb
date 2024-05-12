require "mimemagic"

module ImageEncodeCache
  @@cached_base64_codes = Hash.new

  def cached_base64_codes
    @@cached_base64_codes
  end

  def cached_base64_codes= val
    @@cached_base64_codes = val
  end
end

module Jekyll
  module Tags
    class ImageEncodeTag < Liquid::Tag
      include ImageEncodeCache

      def initialize(tag_name, url, options)
        @url = url.strip
        super
      end

      def lookup(context, name)
        lookup = context
        name.split(".").each { |value| lookup = lookup[value] }
        lookup
      end

      def render(context)
        require 'open-uri'
        require 'base64'

        encoded_image = ''
        image_handle = open(lookup(context, @url))

        if self.cached_base64_codes.has_key? lookup(context, @url)
          encoded_image = self.cached_base64_codes[lookup(context, @url)]
        else
          # p "Caching #{@url} as local base64 string ..."
          encoded_image = Base64.strict_encode64(image_handle.read)
          self.cached_base64_codes.merge!(lookup(context, @url) => encoded_image)
        end

        data_type = MimeMagic.by_magic(image_handle)
        image_handle.close

        "data:#{data_type};base64,#{encoded_image}"
      end
    end
  end
end

Liquid::Template.register_tag('base64', Jekyll::Tags::ImageEncodeTag)
