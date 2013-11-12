class CreateCertificateValidations < ActiveRecord::Migration
  def change
    create_table :certificate_validations do |t|
      t.integer :user_id
      t.integer :certificate_id
      t.integer :value

      t.timestamps
    end
  end
end
