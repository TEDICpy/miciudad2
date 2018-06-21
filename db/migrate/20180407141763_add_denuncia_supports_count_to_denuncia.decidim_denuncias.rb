# This migration comes from decidim_denuncias (originally 20171013090432)
# frozen_string_literal: true

class AddDenunciaSupportsCountToDenuncia < ActiveRecord::Migration[5.1]
  def change
    add_column :decidim_denuncias, :denuncia_supports_count, :integer, null: false, default: 0

    reversible do |change|
      change.up do
        Decidim::Denuncia.find_each do |denuncia|
          denuncia.denuncia_supports_count = denuncia.votes.supports.count
          denuncia.save
        end
      end
    end
  end
end
