class SetDefaultCertificateAttainedLevel < ActiveRecord::Migration
  def up
    Certificate.where('attained_level is null').update_all(attained_level: 'none')
  end

  def down
  end
end
