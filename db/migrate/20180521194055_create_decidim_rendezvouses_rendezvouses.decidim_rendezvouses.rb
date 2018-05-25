# This migration comes from decidim_rendezvouses (originally 20180516142249)
class CreateDecidimRendezvousesRendezvouses < ActiveRecord::Migration[5.1]
  def change
    create_table :decidim_rendezvouses_rendezvouses do |t|
      t.jsonb :title
      t.jsonb :description
      t.datetime :start_time
      t.datetime :end_time
      t.text :address
      t.jsonb :location
      t.jsonb :location_hints
      t.references :decidim_author, index: true
      t.references :decidim_scope, index: true
      t.references :decidim_organization, index: {name: "idx_rendezvous_id_on_organization_id"}
      t.jsonb :closing_report
      t.integer :attendees_count
      t.text :attending_organizations
      t.datetime :closed_at, index: true
      t.float :latitude
      t.float :longitude
      t.string :reference
      t.boolean :registrations_enabled, null: false, default: false
      t.integer :available_slots, null: false, default: 0
      t.jsonb :registration_terms

      t.timestamps
    end
  end
end
