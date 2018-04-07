# This migration comes from decidim_denuncias (originally 20170922152432)
# frozen_string_literal: true

# Migration that creates the decidim_denuncias_committee_members table
class CreateDecidimDenunciasCommitteeMembers < ActiveRecord::Migration[5.1]
  def change
    create_table :decidim_denuncias_committee_members do |t|
      t.references :decidim_denuncias, index: {
        name: "index_decidim_committee_members_denuncia"
      }
      t.references :decidim_users, index: {
        name: "index_decidim_committee_members_user_denuncia"
      }
      t.integer :state, index: true, null: false, default: 0

      t.timestamps
    end
  end
end
