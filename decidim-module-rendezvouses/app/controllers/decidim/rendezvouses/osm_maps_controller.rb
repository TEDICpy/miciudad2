# frozen_string_literal: true

module Decidim
  module Rendezvouses
    class OsmMapsController < Decidim::ApplicationController
      skip_authorization_check

      def show
        send_data Decidim::Rendezvouses::StaticMapGenerator.new(resource).data, type: "image/jpeg", disposition: "inline"
      end

      private

      def resource
        @resource ||= GlobalID::Locator.locate_signed params[:sgid]
      end
    end
  end
end