# This migration comes from decidim_denuncias (originally 20170928160302)
# frozen_string_literal: true

class AddDecidimUserGroupIdToDecidimDenunciasVotes < ActiveRecord::Migration[5.1]
  def change
    add_column :decidim_denuncias_votes,
               :decidim_user_group_id, :integer, index: true
  end
end
