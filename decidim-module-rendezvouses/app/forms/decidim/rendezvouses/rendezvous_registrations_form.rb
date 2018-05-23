# frozen_string_literal: true

module Decidim
  module Rendezvouses
    # This class holds a Form to update rendezvous registrations from Decidim's admin panel.
    class RendezvousRegistrationsForm < Decidim::Form
      include TranslatableAttributes

      mimic :rendezvous

      attribute :registrations_enabled, Boolean
      attribute :available_slots, Integer
      translatable_attribute :registration_terms, String

      validates :registration_terms, translatable_presence: true, if: ->(form) {form.registrations_enabled?}
      validates :available_slots, numericality: {greater_than_or_equal_to: 0}, if: ->(form) {form.registrations_enabled?}
      validate :available_slots_greater_than_or_equal_to_registrations_count, if: ->(form) {form.registrations_enabled? && form.available_slots.positive?}

      # We need this method to ensure the form object will always have an ID,
      # and thus its `to_param` method will always return a significant value.
      # If we remove this method, get an error on the `update` action and try
      # to resubmit the form, the form will not hold an ID, so the `to_param`
      # method will return an empty string and Rails will treat this as a
      # `create` action, thus raising an error since this action is not defined
      # for the controller we're using.
      #
      # TL;DR: if you remove this method, we'll get errors, so don't.
      def id
        return super if super.present?
        rendezvous.id
      end

      private

      def available_slots_greater_than_or_equal_to_registrations_count
        errors.add(:available_slots, :invalid) if available_slots < rendezvous.registrations.count
      end

      def rendezvous
        @rendezvous ||= context[:rendezvous]
      end
    end
  end
end

