# frozen_string_literal: true

module Decidim
  module Rendezvouses
    # This is the engine that runs on the public interface of `Rendezvouses`.
    class AdminEngine < ::Rails::Engine
      isolate_namespace Decidim::Rendezvouses::Admin

      paths["db/migrate"] = nil

      routes do
        # Add admin engine routes here
        # resources :rendezvouses do
        #   collection do
        #     resources :exports, only: [:create]
        #   end
        # end
        # root to: "rendezvouses#index"
      end

      initializer "decidim_rendezvouses.inject_abilities_to_user" do |_app|
        Decidim.configure do |config|
          config.admin_abilities += ["Decidim::Rendezvouses::Abilities::Admin::AdminAbility"]
        end
      end

      def load_seed
        nil
      end
    end
  end
end
