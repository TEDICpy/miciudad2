# frozen_string_literal: true

module Decidim
  module Rendezvouses
    class UpcomingRendezvousNotificationJob < ApplicationJob
      queue_as :events

      def perform(rendezvous_id, checksum)
        rendezvous = Decidim::Rendezvouses::Rendezvous.find(rendezvous_id)
        send_notification(rendezvous) if verify_checksum(rendezvous, checksum)
      end

      def self.generate_checksum(rendezvous)
        Digest::MD5.hexdigest("#{rendezvous.id}-#{rendezvous.start_time}")
      end

      private

      def send_notification(rendezvous)
        Decidim::EventsManager.publish(
            event: "decidim.events.rendezvouses.upcoming_rendezvous",
            event_class: Decidim::Rendezvouses::UpcomingRendezvousEvent,
            resource: rendezvous,
            recipient_ids: rendezvous.followers.pluck(:id)
        )
      end

      def verify_checksum(rendezvous, checksum)
        self.class.generate_checksum(rendezvous) == checksum
      end
    end
  end
end
