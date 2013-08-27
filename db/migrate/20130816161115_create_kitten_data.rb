class CreateKittenData < ActiveRecord::Migration
  def change
    create_table :kitten_data do |t|
      t.text :data
      t.integer :response_set_id

      t.timestamps
    end
  end
end
