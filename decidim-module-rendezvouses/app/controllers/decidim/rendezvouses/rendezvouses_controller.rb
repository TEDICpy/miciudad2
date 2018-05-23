# frozen_string_literal: true

module Decidim
  module Rendezvouses
    class RendezvousesController < Decidim::ApplicationController
      skip_authorization_check

      include Decidim::Rendezvouses::ActionAuthorization
      include FilterResource
      include Paginable
      #include RendezvousSlug
      include FormFactory
      include NeedsOrganization

      helper Decidim::Rendezvouses::ApplicationHelper
      helper Decidim::FiltersHelper
      helper Decidim::ActionAuthorizationHelper
      helper Decidim::WidgetUrlsHelper
      helper Decidim::SanitizeHelper
      helper Decidim::ResourceReferenceHelper

      helper_method :rendezvouses, :geocoded_rendezvouses, :rendezvous #, :current_participatory_space

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

      def new
        @form = form(RendezvousForm).instance
      end

      def create
        @form = form(RendezvousForm).from_params(params)

        CreateRendezvous.call(@form) do
          on(:ok) do
            flash[:notice] = I18n.t("rendezvouses.create.success", scope: "decidim.rendezvouses")
            redirect_to rendezvouses_path
          end

          on(:invalid) do
            flash.now[:alert] = I18n.t("rendezvouses.create.invalid", scope: "decidim.rendezvouses")
            render action: "new"
          end
        end
      end

      private

      def rendezvous
        #@rendezvous ||= Rendezvous.find(id_from_slug params[:id])
        @rendezvous ||= Rendezvous.find(params[:id])
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
            scope_id: ""
        }
      end

      def context_params
        {
            organization: current_organization,
            current_user: current_user
        }
      end

=begin
      private

      alias current_rendezvous current_participatory_space

      def current_participatory_space
        request.env
        @current_participatory_space ||= Rendezvous.find_by(id: id_from_slug(params[:slug]))
      end
=end

    end
  end
end
