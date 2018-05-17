# frozen_string_literal: true

module Decidim::Rendezvouses
  class Registration < ApplicationRecord
    belongs_to :user, foreign_key: "decidim_user_id", class_name: "Decidim::User"
    belongs_to :rendezvous, foreign_key: "decidim_rendezvous_id", class_name: "Decidim::Rendezvouses::Rendezvous"

    validates :user, uniqueness: { scope: :rendezvous }
  end
end
