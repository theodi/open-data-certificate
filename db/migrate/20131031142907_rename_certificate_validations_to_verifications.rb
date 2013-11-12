class RenameCertificateValidationsToVerifications < ActiveRecord::Migration
  def change
    rename_table :certificate_validations, :verifications
  end
end
