# This migration comes from decidim_denuncias (originally 20171023141639)
# frozen_string_literal: true

class OptionalValidationSupportDenunciaType < ActiveRecord::Migration[5.1]
  def change
    add_column :decidim_denuncias_types,
               :requires_validation, :boolean, null: false, default: true
  end
end
