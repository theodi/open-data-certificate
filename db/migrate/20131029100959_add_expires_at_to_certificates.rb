class AddExpiresAtToCertificates < ActiveRecord::Migration
  def change
    add_column :certificates, :expires_at, :datetime
  end
end
