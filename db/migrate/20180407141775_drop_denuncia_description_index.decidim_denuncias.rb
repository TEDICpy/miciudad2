# This migration comes from decidim_denuncias (originally 20171102094250)
# frozen_string_literal: true

class DropDenunciaDescriptionIndex < ActiveRecord::Migration[5.1]
  def change
    remove_index :decidim_denuncias, :description
  end
end
