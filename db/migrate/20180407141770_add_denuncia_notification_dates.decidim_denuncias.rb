# This migration comes from decidim_denuncias (originally 20171019103358)
# frozen_string_literal: true

class AddDenunciaNotificationDates < ActiveRecord::Migration[5.1]
  def change
    add_column :decidim_denuncias,
               :first_progress_notification_at, :datetime, index: true

    add_column :decidim_denuncias,
               :second_progress_notification_at, :datetime, index: true
  end
end
