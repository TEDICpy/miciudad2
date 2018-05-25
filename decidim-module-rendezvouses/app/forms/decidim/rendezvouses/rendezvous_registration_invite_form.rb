# frozen_string_literal: true

module Decidim
  module Rendezvouses
    # A form object used to invite users to join a rendezvous.
    #
    class RendezvousRegistrationInviteForm < Form
      attribute :name, String
      attribute :email, String

      validates :name, :email, presence: true
    end
  end
end
