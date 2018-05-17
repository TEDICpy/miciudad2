# frozen_string_literal : true

module Decidim::Rendezvouses
  class Rendezvous < ApplicationRecord
    include Decidim::Resourceable
    include Decidim::HasAttachments
    include Decidim::HasAttachmentCollections
    include Decidim::HasReference
    #include Decidim::ScopableFeature #TODO: remove if unused
    include Decidim::HasCategory
    include Decidim::Followable
    include Decidim::Comments::Commentable
    include Decidim::Traceable

    has_many :registrations, class_name: "Decidim::Rendezvouses::Registration", foreign_key: "decidim_rendezvous_id", dependent: :destroy

    validates :title, presence: true

    geocoded_by :address, http_headers: ->(proposal) { { "Referer" => proposal.feature.organization.host } }

    scope :past, -> { where(arel_table[:end_time].lteq(Time.current)) }
    scope :upcoming, -> { where(arel_table[:start_time].gt(Time.current)) }

    def closed?
      closed_at.present?
    end

    def has_available_slots?
      return true if available_slots.zero?
      available_slots > registrations.count
    end

    def remaining_slots
      available_slots - registrations.count
    end

    def has_registration_for?(user)
      registrations.where(user: user).any?
    end

    # Public: Overrides the `commentable?` Commentable concern method.
    def commentable?
      feature.settings.comments_enabled?
    end

    # Public: Overrides the `accepts_new_comments?` Commentable concern method.
    def accepts_new_comments?
      commentable? && !feature.current_settings.comments_blocked
    end

    # Public: Overrides the `comments_have_alignment?` Commentable concern method.
    def comments_have_alignment?
      true
    end

    # Public: Overrides the `comments_have_votes?` Commentable concern method.
    def comments_have_votes?
      true
    end

    # Public: Override Commentable concern method `users_to_notify_on_comment_created`
    def users_to_notify_on_comment_created
      followers
    end
  end
end
