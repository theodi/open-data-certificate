class CreateCertificates < ActiveRecord::Migration
  def self.up
    create_table :certificates do |t|
      # Context
      t.integer :response_set_id

      # Content
      t.text :name

      t.timestamps
    end
  end

  def self.down
    drop_table :certificates
  end
end
