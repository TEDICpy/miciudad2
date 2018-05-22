# frozen_string_literal: true

module Decidim
  module Rendezvouses
    module Admin
      # This class holds a Form to close a Rendezvous from Decidim's admin panel.
      class CloseRendezvousForm < Decidim::Form
        include TranslatableAttributes

        translatable_attribute :closing_report, String
        attribute :attendees_count, Integer, default: 0
        attribute :contributions_count, Integer, default: 0
        attribute :attending_organizations, String
        attribute :proposal_ids, Array[Integer]
        attribute :proposals
        attribute :closed_at, DateTime, default: -> (_form, _attribute) { Time.current }

        validates :closing_report, translatable_presence: true
        validates :attendees_count, presence: true, numericality: {greater_than_or_equal_to: 0}
        validates :contributions_count, numericality: true, allow_blank: true
        validates :attending_organizations, presence: true

        # Private: Gets the proposals from the Rendezvous and injects them to the form.
        #
        # Returns nothing.
        def map_model(model)
          self.proposal_ids = model.linked_resources(:proposals, "proposals_from_rendezvous").pluck(:id)
          self.proposals = model.sibling_scope(:proposals)
        end
      end
    end
  end
end