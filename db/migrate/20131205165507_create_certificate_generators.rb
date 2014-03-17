class CreateCertificateGenerators < ActiveRecord::Migration
  def change
    create_table :certificate_generators do |t|
      t.integer :response_set_id
      t.integer :user_id
      t.text :request
      t.timestamps
    end
  end
end
