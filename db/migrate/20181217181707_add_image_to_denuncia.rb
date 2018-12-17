class AddImageToDenuncia < ActiveRecord::Migration[5.1]
  def change
    add_column :decidim_denuncias, :image, :string
  end
end
