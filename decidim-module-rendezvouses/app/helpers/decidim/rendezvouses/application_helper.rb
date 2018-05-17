# frozen_string_literal: true

module Decidim
  module Rendezvouses
    # Custom helpers, scoped to the rendezvouses engine.
    #
    module ApplicationHelper
      include PaginateHelper
      include Decidim::MapHelper
      include Decidim::Rendezvouses::MapHelper
      include Decidim::Rendezvouses::RendezvousesHelper
      include Decidim::Comments::CommentsHelper
    end
  end
end
