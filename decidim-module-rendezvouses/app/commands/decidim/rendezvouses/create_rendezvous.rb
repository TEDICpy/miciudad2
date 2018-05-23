# frozen_string_literal: true

module Decidim
  module Rendezvouses
    # This command is executed when the user creates a Rendezvous
    class CreateRendezvous < Rectify::Command
      def initialize(form)
        @form = form
      end

      # Creates the rendezvous if valid.
      #
      # Broadcasts :ok if successful, :invalid otherwise.
      def call
        @form.decidim_scope_id = @form.scope.id
        return broadcast(:invalid) if @form.invalid?

        transaction do
          create_rendezvous!
          schedule_upcoming_rendezvous_notification
          send_notification
        end

        broadcast(:ok, @rendezvous)
      end

      private

      def create_rendezvous!
        @rendezvous = Decidim.traceability.create!(
            Rendezvous,
            @form.current_user,
            author: @form.current_user,
            scope: @form.scope,
            #category: @form.category,
            title: @form.title,
            description: @form.description,
            end_time: @form.end_time,
            start_time: @form.start_time,
            address: @form.address,
            latitude: @form.latitude,
            longitude: @form.longitude,
            location: @form.location,
            location_hints: @form.location_hints,
            organization: @form.current_organization,
            registrations_enabled: true
        #feature: @form.current_feature
        )
      end

      def schedule_upcoming_rendezvous_notification
        checksum = Decidim::Rendezvouses::UpcomingRendezvousNotificationJob.generate_checksum(@rendezvous)

        Decidim::Rendezvouses::UpcomingRendezvousNotificationJob
            .set(wait_until: @rendezvous.start_time - 2.days)
            .perform_later(@rendezvous.id, checksum)
      end

      def send_notification
        Decidim::EventsManager.publish(
            event: "decidim.events.rendezvouss.rendezvous_created",
            event_class: Decidim::Rendezvouses::CreateRendezvousEvent,
            resource: @rendezvous,
            # TODO: participatory_space why ? where ? how ?
            recipient_ids: @rendezvous.author.followers.pluck(:id)
        )
      end
    end
  end
end

