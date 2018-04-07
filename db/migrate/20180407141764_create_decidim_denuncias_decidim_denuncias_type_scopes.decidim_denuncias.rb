# This migration comes from decidim_denuncias (originally 20171017090551)
# frozen_string_literal: true

class CreateDecidimDenunciasDecidimDenunciasTypeScopes < ActiveRecord::Migration[5.1]
  def change
    create_table :decidim_denuncias_type_scopes do |t|
      t.references :decidim_denuncias_types, index: {name: "idx_scoped_denuncia_type_type" }
      t.references :decidim_scopes, index: { name: "idx_scoped_denuncia_type_scope" }
      t.integer :supports_required, null: false

      t.timestamps
    end
  end
end
