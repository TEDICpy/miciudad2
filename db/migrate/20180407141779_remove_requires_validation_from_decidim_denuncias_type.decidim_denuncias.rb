# This migration comes from decidim_denuncias (originally 20171204103119)
# frozen_string_literal: true

class RemoveRequiresValidationFromDecidimDenunciasType < ActiveRecord::Migration[5.1]
  def change
    remove_column :decidim_denuncias_types,
                  :requires_validation, :boolean, null: false, default: true
  end
end
