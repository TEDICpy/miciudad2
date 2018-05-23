# frozen_string_literal: true

module Decidim
  module Rendezvouses
    # Exposes the registration resource so users can join and leave rendezvouses.
    # :create and :destroy actions are ported from Decidim:Meetings::MeetingsController
    # :edit, :update and the auxiliar :export actions are ported from Admin::MeetingsController
    class RegistrationsController < Decidim::ApplicationController
      skip_authorization_check
      helper Decidim::ActionAuthorizationHelper

      include Decidim::Rendezvouses::ActionAuthorization

      def create
        #authorize! :join, rendezvous

        JoinRendezvous.call(rendezvous, current_user) do
          on(:ok) do
            flash[:notice] = I18n.t("registrations.create.success", scope: "decidim.rendezvouses")
            redirect_to rendezvous_path(rendezvous)
          end

          on(:invalid) do
            flash.now[:alert] = I18n.t("registrations.create.invalid", scope: "decidim.rendezvouses")
            redirect_to rendezvous_path(rendezvous)
          end
        end
      end

      def destroy
        #authorize! :leave, rendezvous

        LeaveRendezvous.call(rendezvous, current_user) do
          on(:ok) do
            flash[:notice] = I18n.t("registrations.destroy.success", scope: "decidim.rendezvouses")
            redirect_to rendezvous_path(rendezvous)
          end

          on(:invalid) do
            flash.now[:alert] = I18n.t("registrations.destroy.invalid", scope: "decidim.rendezvouses")
            redirect_to rendezvous_path(rendezvous)
          end
        end
      end

      def edit
        @form = RendezvousRegistrationsForm.from_model(rendezvous)
      end

      def update
        @form = RendezvousRegistrationsForm.from_params(params).with_context(current_organization: rendezvous.organization, rendezvous: rendezvous)

        UpdateRegistrations.call(@form, rendezvous) do
          on(:ok) do
            flash[:notice] = I18n.t("registrations.update.success", scope: "decidim.rendezvouses")
            redirect_to rendezvouses_path
          end

          on(:invalid) do
            flash.now[:alert] = I18n.t("registrations.update.invalid", scope: "decidim.rendezvouses")
            render action: "edit"
          end
        end
      end

      def export
        format = params[:format]
        export_data = Decidim::Exporters.find_exporter(format).new(rendezvous.registrations, Decidim::Rendezvouses::RegistrationSerializer).export

        send_data export_data.read, type: "text/#{export_data.extension}", filename: export_data.filename("registrations")
      end

      private

      def rendezvous
        @rendezvous ||= Rendezvous.find(params[:rendezvous_id])
      end
    end

  end
end
