# frozen_string_literal: true

module Decidim
  module Rendezvouses
    # This command is executed when the user changes a Rendezvous from the admin
    # panel.
    class UpdateRendezvous < Rectify::Command
      # Initializes a UpdateRendezvous Command.
      #
      # form - The form from which to get the data.
      # rendezvous - The current instance of the page to be updated.
      def initialize(form, rendezvous)
        @form = form
        @rendezvous = rendezvous
      end

      # Updates the rendezvous if valid.
      #
      # Broadcasts :ok if successful, :invalid otherwise.
      def call
        return broadcast(:invalid) if form.invalid?

        transaction do
          update_rendezvous!
          send_notification if should_notify_followers?
          schedule_upcoming_rendezvous_notification if start_time_changed?
        end

        broadcast(:ok, rendezvous)
      end

      private

      attr_reader :form, :rendezvous

      def update_rendezvous!
        Decidim.traceability.update!(
            rendezvous,
            form.current_user,
            scope: form.scope,
            image: form.image,
            remove_image: form.remove_image,
            category: form.category,
            title: form.title,
            description: form.description,
            end_time: form.end_time,
            start_time: form.start_time,
            address: form.address,
            latitude: form.latitude,
            longitude: form.longitude,
            location_hints: form.location_hints
        )
      end

      def send_notification
        Decidim::EventsManager.publish(
            event: "decidim.events.rendezvouses.rendezvous_updated",
            event_class: Decidim::Rendezvouses::UpdateRendezvousEvent,
            resource: rendezvous,
            recipient_ids: rendezvous.followers.pluck(:id)
        )
      end

      def should_notify_followers?
        important_attributes.any? {|attr| rendezvous.previous_changes[attr].present?}
      end

      def important_attributes
        %w(start_time end_time address)
      end

      def start_time_changed?
        rendezvous.previous_changes["start_time"].present?
      end

      def schedule_upcoming_rendezvous_notification
        checksum = Decidim::Rendezvouses::UpcomingRendezvousNotificationJob.generate_checksum(rendezvous)

        Decidim::Rendezvouses::UpcomingRendezvousNotificationJob
            .set(wait_until: rendezvous.start_time - 2.days)
            .perform_later(rendezvous.id, checksum)
      end
    end
  end
end
