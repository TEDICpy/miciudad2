# This migration comes from decidim_denuncias (originally 20170906091626)
# frozen_string_literal: true

class CreateDecidimDenunciasTypes < ActiveRecord::Migration[5.1]
  def change
    create_table :decidim_denuncias_types do |t|
      t.jsonb :title, null: false
      t.jsonb :description, null: false
      t.integer :supports_required, null: false

      t.integer :decidim_organization_id,
                foreign_key: true,
                index: {
                  name: "index_decidim_denuncia_types_on_decidim_organization_id"
                }

      t.timestamps
    end
  end
end
