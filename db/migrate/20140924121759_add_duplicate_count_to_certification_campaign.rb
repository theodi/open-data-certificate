class AddDuplicateCountToCertificationCampaign < ActiveRecord::Migration
  def change
    add_column :certification_campaigns, :duplicate_count, :integer, default: 0
  end
end
