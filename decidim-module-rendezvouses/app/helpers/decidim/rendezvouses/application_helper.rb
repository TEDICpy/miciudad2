# frozen_string_literal: true

require_dependency "action_view/helpers/url_helper"

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
      include ActionView::Helpers::UrlHelper
    end
  end
end
