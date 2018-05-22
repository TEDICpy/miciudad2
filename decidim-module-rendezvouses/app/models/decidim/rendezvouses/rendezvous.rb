# frozen_string_literal : true

module Decidim::Rendezvouses
  class Rendezvous < ApplicationRecord
    include Decidim::Authorable
    include Decidim::Resourceable
    include Decidim::HasAttachments
    include Decidim::HasAttachmentCollections
    include Decidim::HasReference
    include Decidim::Scopable
    include Decidim::HasCategory
    include Decidim::Followable
    include Decidim::Comments::Commentable
    include Decidim::Traceable
    include Decidim::Participable
    include Decidim::Rendezvouses::RendezvousSlug
    include Decidim::Comments::Commentable

    belongs_to :organization,
               foreign_key: "decidim_organization_id",
               class_name: "Decidim::Organization"

    belongs_to :scope,
               foreign_key: "decidim_scope_id",
               class_name: "Decidim::Scope"

    has_one :scope, as: :participatory_space

    has_many :registrations, class_name: "Decidim::Rendezvouses::Registration", foreign_key: "decidim_rendezvous_id", dependent: :destroy

    validates :title, presence: true

    geocoded_by :address, http_headers: ->(proposal) {{"Referer" => proposal.feature.organization.host}}

    scope :past, -> {where(arel_table[:end_time].lteq(Time.current))}
    scope :upcoming, -> {where(arel_table[:start_time].gt(Time.current))}

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

    # Public: Overrides the `comments_have_votes?` Commentable concern method.
    def comments_have_votes?
      true
    end

    # Public: Override Commentable concern method `users_to_notify_on_comment_created`
    def users_to_notify_on_comment_created
      followers
    end

    # Public: Overrides slug attribute from participatory processes.
    def slug
      slug_from_id(id)
    end

    def to_param
      slug
    end

    # Public: Overrides scopes enabled flag available in other models like
    # participatory space or assemblies. For rendezvouses it won't be directly
    # managed by the user and it will be enabled by default.
    def scopes_enabled?
      true
    end

    # Public: Overrides scopes enabled attribute value.
    # For rendezvouses it won't be directly
    # managed by the user and it will be enabled by default.
    def scopes_enabled
      true
    end

    # Public: Whether the object's comments can have have votes or not. It enables the
    # upvote and downvote buttons for comments.
    def comments_have_votes?
      true
    end

    # Public: Defines which users will receive a notification when a comment is created.
    # This method can be overridden at each resource model to include or exclude
    # other users, eg. admins.
    # Returns: a relation of Decidim::User objects.
    def users_to_notify_on_comment_created
      followers
    end

  end
end
