class AddTemplateDatasetToCertificationCampaign < ActiveRecord::Migration
  def change
    add_column :certification_campaigns, :template_dataset_id, :integer
  end
end
