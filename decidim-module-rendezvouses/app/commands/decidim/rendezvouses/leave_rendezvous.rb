# frozen_string_literal: true

module Decidim
  module Rendezvouses
    # This command is executed when the user leaves a rendezvous.
    class LeaveRendezvous < Rectify::Command
      # Initializes a LeaveRendezvous Command.
      #
      # rendezvous - The current instance of the rendezvous to be left.
      # user - The user leaving the rendezvous.
      def initialize(rendezvous, user)
        @rendezvous = rendezvous
        @user = user
      end

      # Destroys a rendezvous registration if the rendezvous has registrations enabled
      # and the registration exists.
      #
      # Broadcasts :ok if successful, :invalid otherwise.
      def call
        @rendezvous.with_lock do
          return broadcast(:invalid) unless registration
          destroy_registration
        end
        broadcast(:ok)
      end

      private

      def registration
        @registration ||= Decidim::Rendezvouses::Registration.where(rendezvous: @rendezvous, user: @user).first
      end

      def destroy_registration
        registration.destroy!
      end
    end
  end
end
