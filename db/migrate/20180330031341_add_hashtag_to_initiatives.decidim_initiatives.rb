# This migration comes from decidim_initiatives (originally 20171011152425)
# frozen_string_literal: true

class AddHashtagToInitiatives < ActiveRecord::Migration[5.1]
  def change
    add_column :decidim_initiatives, :hashtag, :string, unique: true
  end
end
