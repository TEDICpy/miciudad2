# frozen_string_literal: true

module Decidim
  module Rendezvouses
    module Abilities
      # Defines the abilities related to rendezvouses for a logged in user.
      # Intended to be used with `cancancan`.
      class CurrentUserAbility
        include CanCan::Ability

        attr_reader :user, :context

        def initialize(user, context)
          return unless user

          @user = user
          @context = context

          can :join, Rendezvous do |rendezvous|
            authorized?(:join) && rendezvous.registrations_enabled?
          end

          can :leave, Rendezvous, &:registrations_enabled?

          can :edit, Rendezvous do |rendezvous|
            user.admin.eql? true or user.id.eql? rendezvous.author.id
          end

          # can :manage, SomeResource if authorized?(:some_action)
        end

        private

        # Attention! There is references to 0.11 components
        # And we are still using 0.10.1 features
        def authorized?(action)
          # TODO: Must be component ? feature or what ever ?
          return unless component

          ActionAuthorizer.new(user, component, action).authorize.ok?
        end

        def current_settings
          context.fetch(:current_settings, nil)
        end

        def component_settings
          context.fetch(:component_settings, nil)
        end

        def component
          component = context.fetch(:current_component, nil)
          return nil unless component && component.manifest.name == :rendezvouses

          component
        end
      end
    end
  end
end
