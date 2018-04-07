# This migration comes from decidim_denuncias (originally 20171017103029)
# frozen_string_literal: true

class RemoveUnusedAttributesFromDenuncia < ActiveRecord::Migration[5.1]
  def change
    remove_column :decidim_denuncias, :banner_image, :string
    remove_column :decidim_denuncias, :decidim_scope_id, :integer, index: true
    remove_column :decidim_denuncias, :type_id, :integer, index: true
  end
end
