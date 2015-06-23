class AddLatestToCertificateGenerator < ActiveRecord::Migration
  def change
    add_column :certificate_generators, :latest, :boolean, default: true
    add_index :certificate_generators, :latest
  end
end
