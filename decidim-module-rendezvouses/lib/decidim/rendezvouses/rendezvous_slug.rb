# frozen_string_literal: true

module Decidim
  module Rendezvouses
    module RendezvousSlug
      def slug_from_id(id)
        "v-#{id}"
      end

      def id_from_slug(slug)
        return slug if /\A\d+\Z/.match?(slug)

        slug[2..-1] unless slug.blank?
      end
    end
  end
end
