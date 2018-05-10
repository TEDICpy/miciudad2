# frozen_string_literal: true

require "rails"
require "decidim/core"

module Decidim
  module Rendezvouses
    # This is the engine that runs on the public interface of rendezvouses.
    class Engine < ::Rails::Engine
      isolate_namespace Decidim::Rendezvouses

      routes do
        # Add engine routes here
        resources :rendezvouses
        root to: "rendezvouses#index"
      end

      initializer "decidim_rendezvouses.assets" do |app|
        app.config.assets.precompile += %w[decidim_rendezvouses_manifest.js decidim_rendezvouses_manifest.css]
      end

      initializer "decidim_rendezvouses.inject_abilities_to_user" do |_app|
        Decidim.configure do |config|
          config.abilities += ["Decidim::Rendezvouses::Abilities::CurrentUserAbility"]
        end
      end
    end
  end
end
