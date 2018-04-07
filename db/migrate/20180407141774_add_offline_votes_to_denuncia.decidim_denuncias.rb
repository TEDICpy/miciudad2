# This migration comes from decidim_denuncias (originally 20171031183855)
# frozen_string_literal: true

class AddOfflineVotesToDenuncia < ActiveRecord::Migration[5.1]
  def change
    add_column :decidim_denuncias,
               :offline_votes, :integer
  end
end
