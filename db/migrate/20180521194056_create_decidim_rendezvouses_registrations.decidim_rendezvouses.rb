# This migration comes from decidim_rendezvouses (originally 20180516143905)
# frozen_string_literal: true

class CreateDecidimRendezvousesRegistrations < ActiveRecord::Migration[5.1]
  def change
    create_table :decidim_rendezvouses_registrations do |t|
      t.references :decidim_user, foreign_key: true, index: true
      t.integer :decidim_rendezvous_id, foreign_key: true, index: {name: "idx_registrations_id_on_rendezvous_id"}

      t.timestamps
    end
    add_index :decidim_rendezvouses_registrations, [:decidim_user_id, :decidim_rendezvous_id], unique: true, name: "decidim_rendezvouses_registrations_user_rendezvous_unique"
  end
end