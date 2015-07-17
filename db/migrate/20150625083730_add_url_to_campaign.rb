class AddUrlToCampaign < ActiveRecord::Migration
  def change
    add_column :certification_campaigns, :url, :string
  end
end
