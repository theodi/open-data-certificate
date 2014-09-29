class AddUserIdToCertificateCampaign < ActiveRecord::Migration
  def change
    add_column :certification_campaigns, :user_id, :integer
  end
end
