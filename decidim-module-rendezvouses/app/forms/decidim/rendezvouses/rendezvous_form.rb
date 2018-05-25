# frozen_string_literal: true

module Decidim
  module Rendezvouses

    # For to create/update renezvouses
    class RendezvousForm < Decidim::Form
      include TranslatableAttributes

      translatable_attribute :title, String
      translatable_attribute :description, String
      translatable_attribute :location, String
      translatable_attribute :location_hints, String

      attribute :address, String
      attribute :latitude, Float
      attribute :longitude, Float
      attribute :image
      attribute :remove_image
      attribute :start_time, Decidim::Attributes::TimeWithZone
      attribute :end_time, Decidim::Attributes::TimeWithZone
      attribute :decidim_scope_id, Integer
      #attribute :decidim_category_id, Integer

      validates :title, translatable_presence: true
      validates :description, translatable_presence: true
      validates :location, translatable_presence: true
      validates :address, presence: true
      #validates :address, geocoding: true, if: -> {Decidim.geocoder.present?}
      validates :start_time, presence: true, date: {before: :end_time}
      validates :end_time, presence: true, date: {after: :start_time}

      # No Categories and No Features
      #validates :current_feature, presence: true
      #validates :category, presence: true, if: -> (form) {form.decidim_category_id.present?}
      validates :scope, presence: true, if: -> (form) {form.decidim_scope_id.present?}
      validates :image, file_size: { less_than_or_equal_to: ->(_record) { Decidim.maximum_attachment_size } }, file_content_type: { allow: ["image/jpeg", "image/png"] }

      # FIXME: Fix the participatory process space and scope issues
      #validate :scope_belongs_to_participatory_space_scope

      delegate :categories, to: :current_feature

      def map_model(model)
        # FIXME: But must be scope
        return unless model.categorization

        self.decidim_category_id = model.categorization.decidim_category_id
      end

      alias feature current_feature

      # Finds the Scope from the given decidim_scope_id, uses participatory space scope if missing.
      #
      # Returns a Decidim::Scope
      def scope
        # FIXME: Get scope correctly
        @scope ||= context.current_organization.scopes[0]
        #@scope ||= @decidim_scope_id ? current_participatory_space.scopes.find_by(id: @decidim_scope_id) : current_participatory_space.scope
      end

      # Scope identifier
      #
      # Returns the scope identifier related to the meeting
      def decidim_scope_id
        @decidim_scope_id || scope&.id
      end

      # TODO: There is no feature for rendezvous ?
      def category
        return unless current_feature
        @category ||= categories.find_by(id: decidim_category_id)
      end

      private

      # TODO: How must be handled this for a feature-less Module
      def scope_belongs_to_participatory_space_scope
        errors.add(:decidim_scope_id, :invalid) if current_participatory_space.out_of_scope?(scope)
      end
    end
  end
end
