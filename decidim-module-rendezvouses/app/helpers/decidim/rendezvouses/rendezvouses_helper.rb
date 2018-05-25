module Decidim
  module Rendezvouses
    module RendezvousesHelper
      include Decidim::ApplicationHelper
      include Decidim::TranslationsHelper
      include Decidim::ResourceHelper

      # Public: truncates the rendezvous description
      #
      # rendezvous - a Decidim::Rendezvous instance
      # max_length - a number to limit the length of the description
      #
      # Returns the rendezvous' description truncated.
      def rendezvous_description(rendezvous, max_length = 120)
        link = resource_locator(rendezvous).path
        description = translated_attribute(rendezvous.description)
        tail = "... #{link_to(t("read_more", scope: "decidim.rendezvouses"), link)}".html_safe
        CGI.unescapeHTML html_truncate(description, max_length: max_length, tail: tail)
      end
    end
  end
end