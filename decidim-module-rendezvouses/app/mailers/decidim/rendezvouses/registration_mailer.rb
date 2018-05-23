# frozen_string_literal: true

module Decidim
  module Rendezvouses
    # A custom mailer for sending notifications to users when
    # they join a rendezvous.
    class RegistrationMailer < Decidim::ApplicationMailer
      include Decidim::TranslationsHelper
      include ActionView::Helpers::SanitizeHelper

      helper Decidim::ResourceHelper
      helper Decidim::TranslationsHelper

      def confirmation(user, rendezvous)
        with_user(user) do
          @user = user
          @rendezvous = rendezvous
          @organization = @rendezvous.organization
          @locator = Decidim::ResourceLocatorPresenter.new(@rendezvous)

          add_calendar_attachment

          subject = I18n.t("confirmation.subject", scope: "decidim.rendezvouses.mailer.registration_mailer")
          mail(to: user.email, subject: subject)
        end
      end

      private

      def add_calendar_attachment
        calendar = Icalendar::Calendar.new
        calendar.event do |event|
          event.dtstart = Icalendar::Values::DateTime.new(@rendezvous.start_time)
          event.dtend = Icalendar::Values::DateTime.new(@rendezvous.end_time)
          event.summary = translated_attribute @rendezvous.title
          event.description = strip_tags(translated_attribute(@rendezvous.description))
          event.location = @rendezvous.address
          event.geo = [@rendezvous.latitude, @rendezvous.longitude]
          event.url = @locator.url
        end

        attachments["rendezvous-calendar-info.ics"] = calendar.to_ical
      end
    end
  end
end
