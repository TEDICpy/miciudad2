# This migration comes from decidim_denuncias (originally 20171109132011)
# frozen_string_literal: true

class EnablePgExtensionsDenuncia < ActiveRecord::Migration[5.1]
  def change
    enable_extension "pg_trgm"
  rescue ActiveRecord::CatchAll => e
    puts "Can not deal with pg_trgm extension: #{e}"
  end
end
