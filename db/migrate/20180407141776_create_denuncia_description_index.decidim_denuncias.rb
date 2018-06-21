# This migration comes from decidim_denuncias (originally 20171102094556)
# frozen_string_literal: true

class CreateDenunciaDescriptionIndex < ActiveRecord::Migration[5.1]
  def up
    execute "CREATE INDEX decidim_denuncias_description_search ON decidim_denuncias(md5(description::text))"
  end

  def down
    execute "DROP INDEX decidim_denuncias_description_search"
  end
end
