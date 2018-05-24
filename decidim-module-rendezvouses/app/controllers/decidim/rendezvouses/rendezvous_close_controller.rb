# frozen_string_literal: true

module Decidim
  module Rendezvouses
    # This controller allows an admin to manage rendezvouses from a Participatory Process
    class RendezvousCloseController < Decidim::ApplicationController
      helper_method :rendezvous
      skip_authorization_check
      helper Decidim::ActionAuthorizationHelper

      include Decidim::Rendezvouses::ActionAuthorization

      def edit
        @form = CloseRendezvousForm.from_model(rendezvous)
      end

      def update
        @form = CloseRendezvousForm.from_params(params)

        CloseRendezvous.call(@form, rendezvous) do
          on(:ok) do
            flash[:notice] = I18n.t("rendezvouses.close.success", scope: "decidim.rendezvouses")
            redirect_to rendezvouses_path
          end

          on(:invalid) do
            flash.now[:alert] = I18n.t("rendezvouses.close.invalid", scope: "decidim.rendezvouses")
            render action: "edit"
          end
        end
      end

      private

      def rendezvous
        @rendezvous ||= Rendezvous.find(params[:id])
      end
    end
  end
end
