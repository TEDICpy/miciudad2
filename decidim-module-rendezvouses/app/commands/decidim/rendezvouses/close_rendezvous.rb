# frozen_string_literal: true

module Decidim
  module Rendezvouses
    # This command is executed when the user closes a Rendezvous from the admin
    # panel.
    class CloseRendezvous < Rectify::Command
      # Initializes a CloseRendezvous Command.
      #
      # form - The form from which to get the data.
      # rendezvous - The current instance of the page to be closed.
      def initialize(form, rendezvous)
        @form = form
        @rendezvous = rendezvous
      end

      # Closes the rendezvous if valid.
      #
      # Broadcasts :ok if successful, :invalid otherwise.
      def call
        return broadcast(:invalid) if form.invalid?

        transaction do
          close_rendezvous
          #link_proposals
        end

        broadcast(:ok)
      end

      private

      attr_reader :form, :rendezvous

      def close_rendezvous
        Decidim.traceability.perform_action!(
            :close,
            rendezvous,
            form.current_user
        ) do
          rendezvous.update!(
              closing_report: form.closing_report,
              attendees_count: form.attendees_count,
              contributions_count: form.contributions_count,
              attending_organizations: form.attending_organizations,
              closed_at: form.closed_at
          )
        end

        Decidim::EventsManager.publish(
            event: "decidim.events.rendezvouses.rendezvous_closed",
            event_class: Decidim::Rendezvouses::CloseRendezvousEvent,
            resource: rendezvous,
            recipient_ids: rendezvous.followers.pluck(:id)
        )
      end

=begin
      def proposals
        rendezvous.sibling_scope(:proposals).where(id: @form.proposal_ids)
      end
=end

=begin
      def link_proposals
        rendezvous.link_resources(proposals, "proposals_from_rendezvous")
      end
=end
    end
  end
end

