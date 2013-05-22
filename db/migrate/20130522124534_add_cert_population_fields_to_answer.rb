class AddCertPopulationFieldsToAnswer < ActiveRecord::Migration
  def change
    add_column :answers, :text_as_statement, :string

    # display_on_certificate on question only
    #add_column :answers, :display_on_certificate, :boolean, :default => false
  end
end
