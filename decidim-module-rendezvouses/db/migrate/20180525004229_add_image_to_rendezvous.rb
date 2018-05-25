class AddImageToRendezvous < ActiveRecord::Migration[5.1]
  def change
    add_column :decidim_rendezvouses_rendezvouses, :image, :string
  end
end
