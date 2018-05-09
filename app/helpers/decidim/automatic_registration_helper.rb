module Decidim
  module AutomaticRegistrationHelper
    require 'automatic_authorization_handler'

    def authorize_automatically(email, id, organization)
      handler = AutomaticAuthorizationHandler.new
      unique_id = handler.generate_unique_id(email)

      organization = organization
      available_authorizations = organization.available_authorizations || []

      if available_authorizations.include? handler.handler_name
        logger.info("Authorizing user automatically")
        authorization = Decidim::Authorization.create!(name: handler.handler_name,
                                                       metadata: {},
                                                       decidim_user_id: id,
                                                       unique_id: unique_id,
                                                       verification_metadata: {},
                                                       verification_attachment: nil,
                                                       granted_at: Time.now
        )
      end
    end
  end
end