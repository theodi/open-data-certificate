class AddUrlToKittenData < ActiveRecord::Migration
  def change
    add_column :kitten_data, :url, :string
  end
end
