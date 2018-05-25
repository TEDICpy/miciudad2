# frozen_string_literal: true

module Decidim
  module Rendezvouses
    # A custom mailer for sending an invitation to join a rendezvous to
    # an existing user.
    class InviteJoinRendezvousMailer < Decidim::ApplicationMailer
      include Decidim::TranslationsHelper
      include Decidim::SanitizeHelper

      helper Decidim::ResourceHelper
      helper Decidim::TranslationsHelper

      helper_method :routes

      # Send an email to an user to invite them to join a rendezvous.
      #
      # user - The user being invited
      # rendezvous - The rendezvous being joined.
      # invited_by - The user performing the invitation.
      def invite(user, rendezvous, invited_by)
        with_user(user) do
          @user = user
          @rendezvous = rendezvous
          @invited_by = invited_by
          @organization = @rendezvous.organization
          @locator = Decidim::ResourceLocatorPresenter.new(@rendezvous)

          subject = I18n.t("invite.subject", scope: "decidim.rendezvouses.mailer.invite_join_rendezvous_mailer")
          mail(to: user.email, subject: subject)
        end
      end

      private

      def routes
        @routes ||= Decidim::EngineRouter.main_proxy(@rendezvous.feature)
      end
    end
  end
end
