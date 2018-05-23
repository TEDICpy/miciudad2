# frozen_string_literal: true

require "httparty"

module Decidim
  module Rendezvouses
    # This class generates a url to create a static map image for a geocoded resource
    class StaticMapGenerator
      def initialize(resource, options = {})
        @resource = resource
        @options = options

        @options[:zoom] ||= 17
        @options[:width] ||= 120
        @options[:height] ||= 120
      end

      def data
        return if Decidim.geocoder.nil? || @resource.blank?

        Rails.cache.fetch(@resource.cache_key) do
          request = HTTParty.get(uri, headers: {"Referer" => organization.host})
          request.body
        end
      end

      private

      def uri
        coordinates = get_tile_number(@resource.latitude,@resource.longitude, @options[:zoom])
        path = "/#{@options[:zoom]}/#{coordinates[:x]}/#{coordinates[:y]}.png"

        URI.parse(Decidim.geocoder.fetch(:static_map_url) + path)
      end

      def get_tile_number(lat_deg, lng_deg, zoom)
        lat_rad = lat_deg/180 * Math::PI
        n = 2.0 ** zoom
        x = ((lng_deg + 180.0) / 360.0 * n).to_i
        y = ((1.0 - Math::log(Math::tan(lat_rad) + (1 / Math::cos(lat_rad))) / Math::PI) / 2.0 * n).to_i

        {:x => x, :y =>y}
      end

      def organization
        @organization ||= @resource.organization
      end
    end
  end
end