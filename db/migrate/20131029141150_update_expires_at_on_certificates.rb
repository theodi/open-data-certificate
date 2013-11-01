class UpdateExpiresAtOnCertificates < ActiveRecord::Migration
  def up
    Survey.all.map(&:set_expired_certificates)
  end

  def down
  end
end
