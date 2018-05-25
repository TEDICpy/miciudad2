# frozen_string_literal: true

module Decidim
  module Rendezvouses
    module Abilities
      module Admin
        # Defines the abilities related to rendezvouses for a logged in admin user.
        # Intended to be used with `cancancan`.
        class AdminAbility < Decidim::Abilities::AdminAbility
          def define_abilities
            # can :manage, SomeResource
          end
        end
      end
    end
  end
end
