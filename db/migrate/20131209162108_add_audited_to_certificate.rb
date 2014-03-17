class AddAuditedToCertificate < ActiveRecord::Migration
  def change
    add_column :certificates, :audited, :boolean, :default => false
  end
end
