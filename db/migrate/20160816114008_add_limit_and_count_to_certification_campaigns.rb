class AddLimitAndCountToCertificationCampaigns < ActiveRecord::Migration
  def change
    add_column :certification_campaigns, :limit, :integer
    add_column :certification_campaigns, :dataset_count, :integer
  end
end
