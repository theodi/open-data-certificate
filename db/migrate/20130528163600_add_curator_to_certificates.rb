class AddCuratorToCertificates < ActiveRecord::Migration
  def change
    add_column :certificates, :curator, :string
  end
end
