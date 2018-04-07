# This migration comes from decidim_denuncias (originally 20171011152425)
# frozen_string_literal: true

class AddHashtagToDenuncias < ActiveRecord::Migration[5.1]
  def change
    add_column :decidim_denuncias, :hashtag, :string, unique: true
  end
end
