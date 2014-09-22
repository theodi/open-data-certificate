class AddCertificationCampaignIdToCertificateGenerator < ActiveRecord::Migration
  def change
    add_column :certificate_generators, :certification_campaign_id, :integer
  end
end
