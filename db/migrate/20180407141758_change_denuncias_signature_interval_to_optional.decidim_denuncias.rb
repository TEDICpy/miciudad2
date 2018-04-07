# This migration comes from decidim_denuncias (originally 20170927153744)
# frozen_string_literal: true

class ChangeDenunciasSignatureIntervalToOptional < ActiveRecord::Migration[5.1]
  def change
    change_column :decidim_denuncias, :signature_start_time, :date, null: true
    change_column :decidim_denuncias, :signature_end_time, :date, null: true
  end
end
