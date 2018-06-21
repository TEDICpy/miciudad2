# This migration comes from decidim_denuncias (originally 20171023075942)
# frozen_string_literal: true

class CreateDenunciaExtraData < ActiveRecord::Migration[5.1]
  def change
    create_table :decidim_denuncias_extra_data do |t|
      t.references :decidim_denuncia, null: false, index: true
      t.integer :data_type, null: false, default: 0
      t.jsonb :data, null: false
    end
  end
end
