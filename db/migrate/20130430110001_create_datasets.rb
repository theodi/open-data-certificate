class CreateDatasets < ActiveRecord::Migration
  def change
    create_table :datasets do |t|
      t.string :title
      t.string :documentation_url
      t.string :curating_org
      t.string :curator_url
      t.string :data_kind
      t.references :user_id

      t.timestamps
    end

  end
end
