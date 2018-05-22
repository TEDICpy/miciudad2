# frozen_string_literal: true

require "rails"
require "decidim/core"

require_relative '../../../config/initializers/inflections'
require "decidim/rendezvouses/current_locale"
#require "decidim/initiatives/initiatives_filter_form_builder"
require "decidim/rendezvouses/rendezvous_slug"

module Decidim
  module Rendezvouses
    # This is the engine that runs on the public interface of rendezvouses.
    class Engine < ::Rails::Engine
      isolate_namespace Decidim::Rendezvouses

      routes do
        # Add engine routes here
        resources :rendezvouses do
          resource :registration, only: [:create, :destroy] do
            collection do
              get :create
            end
          end
          resource :rendezvous_widget, only: :show, path: "embed"
        end
        #root to: "rendezvouses#index"
      end

      initializer "decidim_rendezvouses.assets" do |app|
        app.config.assets.precompile += %w[decidim_rendezvouses_manifest.js decidim_rendezvouses_manifest.css]
      end

      initializer "decidim_rendezvouses.inject_abilities_to_user" do |_app|
        Decidim.configure do |config|
          config.abilities += ["Decidim::Rendezvouses::Abilities::CurrentUserAbility"]
        end
      end

      initializer "decidim_rendezvouses.menu" do
        Decidim.menu :menu do |menu|
          menu.item I18n.t("menu.rendezvouses", scope: "decidim"),
                    decidim_rendezvouses.rendezvouses_path,
                    position: 2.6,
                    active: :inclusive
        end
      end
    end
  end
end
