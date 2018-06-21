# This migration comes from decidim_denuncias (originally 20170927131354)
# frozen_string_literal: true

class AddDecidimUserGroupIdToDecidimDenuncias < ActiveRecord::Migration[5.1]
  def change
    add_column :decidim_denuncias,
               :decidim_user_group_id, :integer, index: true
  end
end
