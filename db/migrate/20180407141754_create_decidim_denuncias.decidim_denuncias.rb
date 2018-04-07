# This migration comes from decidim_denuncias (originally 20170906094044)
# frozen_string_literal: true

# Migration that creates the decidim_denuncias table
class CreateDecidimDenuncias < ActiveRecord::Migration[5.1]
  def change
    create_table :decidim_denuncias do |t|
      t.jsonb :title, null: false
      t.jsonb :description, null: false

      t.integer :decidim_organization_id,
                foreign_key: true,
                index: {
                  name: "index_decidim_denuncias_on_decidim_organization_id"
                }

      # Text search indexes for denuncias.
      t.index :title, name: "decidim_denuncias_title_search"
      t.index :description, name: "decidim_denuncias_description_search"

      t.references :decidim_author, index: true
      t.string :banner_image

      # Publicable
      t.datetime :published_at, index: true

      # Scopeable
      t.integer :decidim_scope_id, index: true

      t.references :type, index: true
      t.integer :state, null: false, default: 0
      t.integer :signature_type, null: false, default: 0
      t.date :signature_start_time, null: false
      t.date :signature_end_time, null: false
      t.jsonb :answer
      t.datetime :answered_at, index: true
      t.string :answer_url
      t.integer :denuncia_votes_count, null: false, default: 0

      t.timestamps
    end
  end
end
