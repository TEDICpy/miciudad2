# This migration comes from decidim_denuncias (originally 20171011110714)
# frozen_string_literal: true

class AddBannerImageToDenunciaType < ActiveRecord::Migration[5.1]
  def change
    add_column :decidim_denuncias_types, :banner_image, :string
  end
end
