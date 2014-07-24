class AddAasmStateToCertificates < ActiveRecord::Migration
  def up
    add_column :certificates, :aasm_state, :string
    Certificate.where(published: true).each { |c| c.update_attributes(aasm_state: :published) }
    Certificate.where(published: false).each { |c| c.update_attributes(aasm_state: :draft) }
  end

  def down
    remove_column :certificates, :aasm_state
  end
end
