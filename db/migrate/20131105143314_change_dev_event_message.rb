class ChangeDevEventMessage < ActiveRecord::Migration
  def up
    change_table :dev_events do |t|
      t.change :message, :text, limit: 65535
    end
  end
 
  def down
    change_table :dev_events do |t|
      t.change :message, :string
    end
  end
end
