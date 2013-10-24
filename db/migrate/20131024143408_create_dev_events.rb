class CreateDevEvents < ActiveRecord::Migration
  def change
    create_table :dev_events do |t|
      t.string :message

      t.timestamps
    end
  end
end
