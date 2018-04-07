# This migration comes from decidim_denuncias (originally 20170928160912)
# frozen_string_literal: true

class RemoveScopeFromDecidimDenunciasVotes < ActiveRecord::Migration[5.1]
  def change
    remove_column :decidim_denuncias_votes, :scope, :integer
  end
end
