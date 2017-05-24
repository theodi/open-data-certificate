class AddIncludeHarvestedToCertificationCampaigns < ActiveRecord::Migration
  def change
    add_column :certification_campaigns, :include_harvested, :boolean, default: false
  end
end
