class AddCompletedToCertificateGenerator < ActiveRecord::Migration
  def change
    add_column :certificate_generators, :completed, :boolean
  end
end
