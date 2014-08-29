class CreateStats < ActiveRecord::Migration
  def change
    create_table :stats do |t|
      t.string  :name
      t.integer :all
      t.integer :expired
      t.integer :publishers
      t.integer :this_month
      t.integer :level_none
      t.integer :level_basic
      t.integer :level_pilot
      t.integer :level_standard
      t.integer :level_exemplar

      t.timestamps
    end
  end
end
