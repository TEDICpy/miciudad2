# frozen_string_literal: true

module Decidim
  module Rendezvouses
    class RendezvousWidgetsController < Decidim::WidgetsController
      helper RendezvousesHelper
      helper Decidim::SanitizeHelper

      private

      def model
        @model ||= Rendezvous.find(params[:rendezvous_id])
      end

      def iframe_url
        @iframe_url ||= rendezvous_rendezvous_widget_url(model)
      end
    end
  end
end
