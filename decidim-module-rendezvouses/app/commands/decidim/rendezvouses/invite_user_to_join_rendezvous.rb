# frozen_string_literal: true

module Decidim
  module Rendezvouses
    # A command with all the business logic to invite users to join a rendezvous.
    #
    class InviteUserToJoinRendezvous < Rectify::Command
      # Public: Initializes the command.
      #
      # form         - A form object with the params.
      # rendezvous      - The rendezvous which the user is invited to.
      # invited_by   - The user performing the operation
      def initialize(form, rendezvous, invited_by)
        @form = form
        @rendezvous = rendezvous
        @invited_by = invited_by
      end

      # Executes the command. Broadcasts these events:
      #
      # - :ok when everything is valid.
      # - :invalid if the form wasn't valid and we couldn't proceed.
      #
      # Returns nothing.
      def call
        return broadcast(:invalid) if form.invalid?

        invite_user

        broadcast(:ok)
      end

      private

      attr_reader :form, :invited_by, :rendezvous

      def invite_user
        if user.persisted?
          InviteJoinRendezvousMailer.invite(user, rendezvous, invited_by).deliver_later
        else
          user.name = form.name
          user.nickname = User.nicknamize(user.name)
          user.skip_reconfirmation!
          user.invite!(invited_by, invitation_instructions: "join_rendezvous", rendezvous: rendezvous)
        end
      end

      def user
        @user ||= Decidim::User.find_or_create_by(
            organization: form.current_organization,
            email: form.email.downcase
        )
      end
    end
  end
end
