class AddSubsetToCertificationCampaign < ActiveRecord::Migration
  def change
    add_column :certification_campaigns, :subset, :text
  end
end
