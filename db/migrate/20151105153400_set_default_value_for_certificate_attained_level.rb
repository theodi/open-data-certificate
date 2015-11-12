class SetDefaultValueForCertificateAttainedLevel < ActiveRecord::Migration
  def up
    change_column_default :certificates, :attained_level, 'none'
  end

  def down
  end
end
