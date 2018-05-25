# frozen_string_literal: true

module Decidim
  module Rendezvouses
    # This helper include some methods for rendering rendezvouses dynamic maps.
    module MapHelper
      # Serialize a collection of geocoded rendezvouses to be used by the dynamic map component
      #
      # geocoded_rendezvouses - A collection of geocoded rendezvouses
      def rendezvouses_data_for_map(geocoded_rendezvouses)
        geocoded_rendezvouses.map do |rendezvous|
          rendezvous
              .slice(:latitude, :longitude, :address)
              .merge(title: translated_attribute(rendezvous.title),
                     description: translated_attribute(rendezvous.description),
                     startTimeDay: l(rendezvous.start_time, format: "%d"),
                     startTimeMonth: l(rendezvous.start_time, format: "%B"),
                     startTimeYear: l(rendezvous.start_time, format: "%Y"),
                     startTime: "#{rendezvous.start_time.strftime("%H:%M")} - #{rendezvous.end_time.strftime("%H:%M")}",
                     icon: icon("rendezvouses", width: 40, height: 70, remove_icon_class: true),
                     location: translated_attribute(rendezvous.location),
                     locationHints: translated_attribute(rendezvous.location_hints),
                     link: rendezvous_path(rendezvous))
        end
      end

      def static_map_link_osm(resource, options = {})
        return unless resource.geocoded?

        zoom = options[:zoom] || 17
        latitude = resource.latitude
        longitude = resource.longitude

        map_url = "https://www.openstreetmap.org/?mlat=#{latitude}&mlon=#{longitude}#map=#{zoom}/#{latitude}/#{longitude}"

        link_to map_url, target: "_blank" do
          image_tag rendezvous_osm_maps_path(rendezvous_id: resource.id, sgid: resource.to_sgid.to_s)
        end
      end
    end
  end
end
