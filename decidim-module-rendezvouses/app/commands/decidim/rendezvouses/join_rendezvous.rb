# frozen_string_literal: true

module Decidim
  module Rendezvouses
    # This command is executed when the user joins a rendezvous.
    class JoinRendezvous < Rectify::Command
      # Initializes a JoinRendezvous Command.
      #
      # rendezvous - The current instance of the rendezvous to be joined.
      # user - The user joining the rendezvous.
      def initialize(rendezvous, user)
        @rendezvous = rendezvous
        @user = user
      end

      # Creates a rendezvous registration if the rendezvous has registrations enabled
      # and there are available slots.
      #
      # Broadcasts :ok if successful, :invalid otherwise.
      def call
        rendezvous.with_lock do
          return broadcast(:invalid) unless can_join_rendezvous?
          create_registration
          send_email_confirmation
          send_notification
        end
        broadcast(:ok)
      end

      private

      attr_reader :rendezvous, :user

      def create_registration
        Decidim::Rendezvouses::Registration.create!(rendezvous: rendezvous, user: user)
      end

      def can_join_rendezvous?
        rendezvous.registrations_enabled? && rendezvous.has_available_slots?
      end

      def send_email_confirmation
        Decidim::Rendezvouses::RegistrationMailer.confirmation(user, rendezvous).deliver_later
      end

      def participatory_space_admins
        # Use Organization
        @rendezvous.organization.admins
      end

      def send_notification
        return send_notification_over(0.5) if occupied_slots_over?(0.5)
        return send_notification_over(0.8) if occupied_slots_over?(0.8)
        send_notification_over(1.0) if occupied_slots_over?(1.0)
      end

      def send_notification_over(percentage)
        Decidim::EventsManager.publish(
            event: "decidim.events.rendezvouses.rendezvous_registrations_over_percentage",
            event_class: Decidim::Rendezvouses::RendezvousRegistrationsOverPercentageEvent,
            resource: @rendezvous,
            recipient_ids: participatory_space_admins.pluck(:id),
            extra: {
                percentage: percentage
            }
        )
      end

      def occupied_slots_over?(percentage)
        @rendezvous.remaining_slots == (@rendezvous.available_slots * (1 - percentage)).round
      end
    end
  end
end
