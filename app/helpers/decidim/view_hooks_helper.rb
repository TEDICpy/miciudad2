require "active_support/concern"
module Decidim
  module ViewHooksHelper
    include Decidim::Rendezvouses::RendezvousesHelper

    # Public: Renders all hooks registered as `hook_name`.
    #
    #   Note: We're passing a deep copy of the view context to allow
    #   us to extend it without polluting the original view context
    #
    # This handle rendering intiatives and denuncias but not
    # processes
    #
    # @param hook_name [Symbol] representing the name of the hook.
    #
    # @return [String] an HTML safe String
    def render_custom_hook(hook_name)
      a = render_initiatives(deep_dup)
      b = render_denuncias(deep_dup)
      [a, b].join("").html_safe
    end

    def rendezvouses
      next_rendezvouses(deep_dup)
    end

    def next_rendezvouses(view_context)
      search = Decidim::Rendezvouses::RendezvousSearch.new({:date => "upcoming"})
      next_rendezvouses = search.results
    end

    def render_initiatives(view_context)
      highlighted_initiatives = Decidim::Initiatives::OrganizationPrioritizedInitiatives.new(view_context.current_organization)

      return "" unless highlighted_initiatives.any?

      view_context.render(
          partial: "decidim/initiatives/pages/home/highlighted_initiatives",
          locals: {
              highlighted_initiatives: highlighted_initiatives
          }
      )
    end

    def render_denuncias(view_context)
      highlighted_denuncias = Decidim::Denuncias::OrganizationPrioritizedDenuncias.new(view_context.current_organization)

      return "" unless highlighted_denuncias.any?

      view_context.render(
          partial: "decidim/denuncias/pages/home/highlighted_denuncias",
          locals: {
              highlighted_denuncias: highlighted_denuncias
          }
      )
    end

    # Public: Renders all hooks registered as `hook_name`.
    #
    #   Note: We're passing a deep copy of the view context to allow
    #   us to extend it without polluting the original view context
    #
    # @param hook_name [Symbol] representing the name of the hook.
    #
    # @return [String] an HTML safe String
    def render_hook(hook_name)
      Decidim.view_hooks.render(hook_name, deep_dup)
    end
  end
end