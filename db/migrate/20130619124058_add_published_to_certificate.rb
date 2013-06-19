class AddPublishedToCertificate < ActiveRecord::Migration
  def change
    add_column :certificates, :published, :boolean, :default => false
  end
end
