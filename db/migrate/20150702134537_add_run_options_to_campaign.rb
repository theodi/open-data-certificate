class AddRunOptionsToCampaign < ActiveRecord::Migration
  def change
    add_column :certification_campaigns, :jurisdiction, :string, default: 'gb'
  end
end
