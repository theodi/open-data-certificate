class CreateCertificationCampaigns < ActiveRecord::Migration
  def change
    create_table :certification_campaigns do |t|
      t.string :name

      t.timestamps
    end
  end
end
