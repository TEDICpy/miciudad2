# This migration comes from decidim_rendezvouses (originally 20180525004229)
class AddImageToRendezvous < ActiveRecord::Migration[5.1]
  def change
    add_column :decidim_rendezvouses_rendezvouses, :image, :string
  end
end
