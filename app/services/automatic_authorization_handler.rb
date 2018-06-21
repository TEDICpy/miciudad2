# frozen_string_literal:true
# Authorization Automatica por defecto
require "digest/md5"

class AutomaticAuthorizationHandler < Decidim::AuthorizationHandler

  include ActionView::Helpers::SanitizeHelper

  validate :check_response

  def metadata
    super
  end

  def unique_id
    generate_unique_id user.email
  end

  # Always true by default
  def check_response
    true
  end

  def generate_unique_id(identifier)
    Digest::MD5.hexdigest("#{identifier}-#{Rails.application.secrets.secret_key_base}")
  end
end