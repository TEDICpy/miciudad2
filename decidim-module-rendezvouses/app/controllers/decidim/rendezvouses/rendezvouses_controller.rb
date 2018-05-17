# frozen_string_literal: true

module Decidim
  module Rendezvouses
    class RendezvousesController < Decidim::ApplicationController
      skip_authorization_check
      #include ParticipatorySpaceContext
      #participatory_space_layout

      include ActionAuthorization
      include FilterResource
      include Paginable
      include RendezvousSlug

      helper Decidim::Rendezvouses::ApplicationHelper
      helper Decidim::FiltersHelper
      helper Decidim::ActionAuthorizationHelper
      helper Decidim::WidgetUrlsHelper

      helper_method :rendezvouses, :geocoded_rendezvouses, :rendezvous#, :current_participatory_space


      def index
        return unless search.results.empty? && params.dig("filter", "date") != "past"

        @past_rendezvouses = search_klass.new(search_params.merge(date: "past"))
        unless @past_rendezvouses.results.empty?
          params[:filter] ||= {}
          params[:filter][:date] = "past"
          @forced_past_rendezvouses = true
          @search = @past_rendezvouses
        end
      end

      private

      def rendezvous
        @rendezvous ||= Rendezvous.where(feature: current_feature).find(params[:id])
      end

      def rendezvouses
        @rendezvouses ||= paginate(search.results)
      end

      def geocoded_rendezvouses
        @geocoded_rendezvous ||= search.results.select(&:geocoded?)
      end

      def search_klass
        RendezvousSearch
      end

      def default_filter_params
        {
            date: "upcoming",
            search_text: "",
            scope_id: "" #,
            #category_id: ""
        }
      end

      def context_params
        {
            organization: current_organization,
            current_user: current_user
        }
      end

=begin
      alias current_rendezvous current_participatory_space

      def current_participatory_space
        @current_participatory_space ||= Rendezvous.find_by(id: id_from_slug(params[:slug]))
      end
=end
    end
  end
end
