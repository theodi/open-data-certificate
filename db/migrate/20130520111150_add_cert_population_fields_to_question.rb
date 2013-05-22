class AddCertPopulationFieldsToQuestion < ActiveRecord::Migration
  def change
    add_column :questions, :text_as_statement, :string
    add_column :questions, :display_on_certificate, :boolean, :default => false
  end
end
