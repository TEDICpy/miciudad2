# frozen_string_literal: true

module Decidim
  module Rendezvouses
    # This command is executed when the user updates the rendezvous registrations.
    class UpdateRegistrations < Rectify::Command
      # Initializes a UpdateRegistrations Command.
      #
      # form - The form from which to get the data.
      # rendezvous - The current instance of the rendezvous to be updated.
      def initialize(form, rendezvous)
        @form = form
        @rendezvous = rendezvous
      end

      # Updates the rendezvous if valid.
      #
      # Broadcasts :ok if successful, :invalid otherwise.
      def call
        rendezvous.with_lock do
          return broadcast(:invalid) if form.invalid?
          update_rendezvous_registrations
          send_notification if should_notify_followers?
        end

        broadcast(:ok)
      end

      private

      attr_reader :form, :rendezvous

      def update_rendezvous_registrations
        rendezvous.registrations_enabled = form.registrations_enabled

        if form.registrations_enabled
          rendezvous.available_slots = form.available_slots
          rendezvous.registration_terms = form.registration_terms
        end

        rendezvous.save!
      end

      def send_notification
        Decidim::EventsManager.publish(
            event: "decidim.events.rendezvouses.registrations_enabled",
            event_class: Decidim::Rendezvouses::RendezvousRegistrationsEnabledEvent,
            resource: rendezvous,
            recipient_ids: rendezvous.followers.pluck(:id)
        )
      end

      def should_notify_followers?
        rendezvous.previous_changes["registrations_enabled"].present? && rendezvous.registrations_enabled?
      end
    end
  end
end
