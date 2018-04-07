# This migration comes from decidim_denuncias (originally 20171017091458)
# frozen_string_literal: true

class RemoveSupportsRequiredFromDecidimDenunciasTypes < ActiveRecord::Migration[5.1]
  def change
    remove_column :decidim_denuncias_types, :supports_required, :integer, null: false
  end
end
