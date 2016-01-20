class ExpandKittenDataField < ActiveRecord::Migration
  def change
    # 16.megabytes - 1 should trigger a column type of MEDIUMTEXT on MySQL
    change_column :kitten_data, :data, :text, :limit => 16.megabytes - 1
  end
end
