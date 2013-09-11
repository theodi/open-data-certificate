class UpdateKittenData < ActiveRecord::Migration
  def up
    KittenData.reset_column_information
    KittenData.all.each do |kitten_data|
      kitten_data.request_data
      kitten_data.save
    end
  end
end
