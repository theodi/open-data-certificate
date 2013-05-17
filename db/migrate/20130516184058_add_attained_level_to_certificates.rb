class AddAttainedLevelToCertificates < ActiveRecord::Migration
  def change
    add_column :certificates, :attained_level, :string
  end
end
