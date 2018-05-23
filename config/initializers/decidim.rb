# frozen_string_literal: true

Decidim.configure do |config|
  config.application_name = "Mi Ciudad"
  config.mailer_sender = "miciudad@tedic.net"

  # Change these lines to set your preferred locales
  config.default_locale = :es
  config.available_locales = [:es, :en]

  # Hanlders de autorización para Mi ciudad
  config.authorization_handlers = [MailAuthorizationHandler, AutomaticAuthorizationHandler]

  # Geocoder configuration
  config.geocoder = {
     #static_map_url: "https://image.maps.cit.api.here.com/mia/1.6/mapview",
     #static_map_url: "https://maps.wikimedia.org/osm-intl", #/${z}/${x}/${y}.png
     static_map_url: "https://tile.openstreetmap.org", #/${z}/${x}/${y}.png
     here_app_id: Rails.application.secrets.geocoder[:here_app_id],
     here_app_code: Rails.application.secrets.geocoder[:here_app_code]
  }

  # Custom resource reference generator method
  # config.reference_generator = lambda do |resource, feature|
  #   # Implement your custom method to generate resources references
  #   "1234-#{resource.id}"
  # end

  # Currency unit
  # config.currency_unit = "€"

  # The number of reports which an object can receive before hiding it
  # config.max_reports_before_hiding = 3

  # Custom HTML Header snippets
  #
  # The most common use is to integrate third-party services that require some
  # extra JavaScript or CSS. Also, you can use it to add extra meta tags to the
  # HTML. Note that this will only be rendered in public pages, not in the admin
  # section.
  #
  # Before enabling this you should ensure that any tracking that might be done
  # is in accordance with the rules and regulations that apply to your
  # environment and usage scenarios. This feature also comes with the risk
  # that an organization's administrator injects malicious scripts to spy on or
  # take over user accounts.
  #
  config.enable_html_header_snippets = false
end


Decidim::Verifications.register_workflow(:mail_authorization_handler) do |auth|
  auth.form = "MailAuthorizationHandler"
end
Decidim::Verifications.register_workflow(:automatic_authorization_handler) do |auth|
  auth.form = "AutomaticAuthorizationHandler"
end

Rails.application.config.i18n.available_locales = Decidim.available_locales
Rails.application.config.i18n.default_locale = Decidim.default_locale
