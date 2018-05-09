# frozen_string_literal:true
# Verifica la dirección de email como requisito de autorización
require "digest/md5"

class MailAuthorizationHandler < Decidim::AuthorizationHandler

  include ActionView::Helpers::SanitizeHelper

  attribute :verification_code, String

  validates :verification_code, presence: true

  validate :check_response

  def metadata
    super
  end

  def unique_id
    Digest::MD5.hexdigest("#{verification_code}-#{Rails.application.secrets.secret_key_base}")
  end

  def check_response
    errors.add(:base, :invalid) unless verify_user_code
  end


  # TODO: improve verification with custom logic
  # For now just the plain email address of the user is used ?
  def verify_user_code
    user.email.eql? verification_code
  end

end