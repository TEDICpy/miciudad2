# frozen_string_literal: true

module Decidim
  module Rendezvouses
    # This command is executed when the user destroys a Rendezvous from the admin
    # panel.
    class DestroyRendezvous < Rectify::Command
      # Initializes a CloseRendezvous Command.
      #
      # rendezvous - The current instance of the page to be closed.
      # current_user - the user performing the action
      def initialize(rendezvous, current_user)
        @rendezvous = rendezvous
        @current_user = current_user
      end

      # Destroys the rendezvous if valid.
      #
      # Broadcasts :ok if successful, :invalid otherwise.
      def call
        destroy_rendezvous

        broadcast(:ok)
      end

      private

      attr_reader :current_user, :rendezvous

      def destroy_rendezvous
        Decidim.traceability.perform_action!(
            :delete,
            rendezvous,
            current_user
        ) do
          rendezvous.destroy!
        end
      end
    end
  end
end
