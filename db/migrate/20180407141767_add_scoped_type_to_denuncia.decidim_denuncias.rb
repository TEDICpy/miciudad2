# This migration comes from decidim_denuncias (originally 20171017094911)
# frozen_string_literal: true

class AddScopedTypeToDenuncia < ActiveRecord::Migration[5.1]
  def change
    add_column :decidim_denuncias,
               :scoped_type_id, :integer, index: true
  end
end
