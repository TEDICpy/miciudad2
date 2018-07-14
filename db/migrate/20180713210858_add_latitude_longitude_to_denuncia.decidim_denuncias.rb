# This migration comes from decidim_denuncias (originally 20180713210735)
class AddLatitudeLongitudeToDenuncia < ActiveRecord::Migration[5.1]
  def change
    add_column :decidim_denuncias, :latitude, :float
    add_column :decidim_denuncias, :longitude, :float
  end
end
