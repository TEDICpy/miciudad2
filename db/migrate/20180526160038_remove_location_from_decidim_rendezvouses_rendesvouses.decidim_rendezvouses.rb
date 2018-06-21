# This migration comes from decidim_rendezvouses (originally 20180526155749)
class RemoveLocationFromDecidimRendezvousesRendesvouses < ActiveRecord::Migration[5.1]
  def change
    remove_column :decidim_rendezvouses_rendezvouses, :location, :jsonb
  end
end
